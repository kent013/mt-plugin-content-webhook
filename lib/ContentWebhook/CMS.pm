package ContentWebhook::CMS;

use strict;
use warnings;

# システム設定画面の表示
sub config {
    my $app = shift;

    # プラグイン設定を取得
    my $plugin = MT->component('ContentWebhook');
    my $webhook_url = $plugin->get_config_value('webhook_url', 'system') || '';

    my %param = (
        webhook_url => $webhook_url,
    );

    return $app->load_tmpl('system_config.tmpl', \%param);
}

# 設定の保存
sub save_config {
    my $app = shift;

    # パラメータを取得
    my $webhook_url = $app->param('webhook_url') || '';

    # 設定を保存
    my $plugin = MT->component('ContentWebhook');
    $plugin->set_config_value('webhook_url', $webhook_url, 'system');

    # 成功メッセージ
    $app->add_return_arg(saved => 1);

    return $app->redirect($app->uri(
        mode => 'content_webhook_config',
        args => { saved => 1 }
    ));
}



1;
