package ContentWebhook::Callback;

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use HTTP::Request;

# コンテンツデータ保存後の処理
sub post_save_content_data {
    my ($cb, $app, $obj, $orig_obj) = @_;

    # プラグイン設定を取得
    my $plugin = MT->component('ContentWebhook');
    my $webhook_url = $plugin->get_config_value('webhook_url', 'system') || '';

    # URLが設定されていない場合は何もしない
    return 1 unless $webhook_url && $webhook_url =~ /^https?:\/\//;

    # 公開状態のコンテンツのみ処理
    require MT::ContentStatus;
    return 1 unless $obj->status == MT::ContentStatus::RELEASE();

    # Webhook送信データを作成
    my $webhook_data = _create_webhook_data($obj, 'content_data.saved');

    # Webhookを送信
    _send_webhook_with_logging($app, $webhook_url, $webhook_data, $obj->id);

    return 1;
}

# コンテンツデータ削除後の処理
sub post_delete_content_data {
    my ($cb, $app, $obj) = @_;

    # プラグイン設定を取得
    my $plugin = MT->component('ContentWebhook');
    my $webhook_url = $plugin->get_config_value('webhook_url', 'system') || '';

    # URLが設定されていない場合は何もしない
    return 1 unless $webhook_url && $webhook_url =~ /^https?:\/\//;

    # Webhook送信データを作成
    my $webhook_data = _create_webhook_data($obj, 'content_data.deleted');

    # Webhookを送信
    _send_webhook_with_logging($app, $webhook_url, $webhook_data, $obj->id);

    return 1;
}

# Webhookデータを作成
sub _create_webhook_data {
    my ($obj, $event) = @_;

    # コンテンツタイプ情報を取得
    my $content_type = $obj->content_type;
    my $content_type_name = $content_type ? $content_type->name : '';

    my $timestamp = _format_timestamp(time());

    return {
        event => $event,
        timestamp => $timestamp,
        data => {
            type => $content_type_name,
            id => $obj->id,
        }
    };
}

# Webhookを送信してログを記録
sub _send_webhook_with_logging {
    my ($app, $url, $webhook_data, $content_id) = @_;

    eval {
        _send_webhook($url, $webhook_data);

        # 成功ログ
        MT->log({
            message => $app->translate(
                'Webhook notification sent for content data ID: [_1]',
                $content_id
            ),
            level    => MT::Log::INFO(),
            class    => 'content_data',
            category => 'content_webhook',
            metadata => $content_id
        });
    };

    if ($@) {
        # エラーログ
        MT->log({
            message => $app->translate(
                'Failed to send webhook for content data ID: [_1]. Error: [_2]',
                $content_id,
                $@
            ),
            level    => MT::Log::ERROR(),
            class    => 'content_data',
            category => 'content_webhook',
            metadata => $content_id
        });
    }
}

# Webhookを送信
sub _send_webhook {
    my ($url, $data) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);  # 固定値10秒
    $ua->agent('MovableType-ContentWebhook/1.0');

    # リダイレクトを自動的に追跡しない
    $ua->max_redirect(0);

    # UTF-8エンコーディングを確実にする
    my $json = JSON->new->utf8(1)->pretty(0);
    my $json_data = eval { $json->encode($data) };

    if ($@) {
        die "Failed to encode JSON: $@";
    }

    my $request = HTTP::Request->new(POST => $url);
    $request->header('Content-Type' => 'application/json');
    $request->header('Accept' => 'application/json');
    $request->content($json_data);

    my $response = $ua->request($request);

    unless ($response->is_success) {
        die "HTTP request failed: " . $response->status_line . ", Body: " . substr($response->content || '', 0, 200);
    }

    return 1;
}

# タイムスタンプをISO8601形式にフォーマット
sub _format_timestamp {
    my ($timestamp) = @_;
    return '' unless $timestamp;

    # Perlのgmtimeを使用してISO8601形式に変換
    my @time = gmtime($timestamp);
    return sprintf('%04d-%02d-%02dT%02d:%02d:%02dZ',
        $time[5] + 1900,  # 年
        $time[4] + 1,     # 月
        $time[3],         # 日
        $time[2],         # 時
        $time[1],         # 分
        $time[0]          # 秒
    );
}

1;
