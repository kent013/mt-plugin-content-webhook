package ContentWebhook::L10N::ja;

use strict;
use warnings;
use base 'ContentWebhook::L10N';
use vars qw( %Lexicon );

%Lexicon = (
    'Send webhook notifications when content data is saved' => 'コンテンツデータ保存時にWebhook通知を送信',
    'Content Webhook Settings' => 'Content Webhook設定',
    'Webhook URL' => 'Webhook URL',
    'Enter webhook URL' => 'Webhook URLを入力してください',
    'Webhook sent successfully' => 'Webhookの送信に成功しました',
    'Timeout (seconds)' => 'タイムアウト（秒）',
    'Retry count' => 'リトライ回数',
    'Test webhook' => 'Webhookテスト',
    'Webhook sent successfully' => 'Webhookの送信に成功しました',
    'Failed to send webhook' => 'Webhookの送信に失敗しました',
    'Content data saved: [_1]' => 'コンテンツデータが保存されました: [_1]',
    'Webhook notification sent for content data ID: [_1]' => 'コンテンツデータID [_1] のWebhook通知を送信しました',
    'Failed to send webhook for content data ID: [_1]. Error: [_2]' => 'コンテンツデータID [_1] のWebhook送信に失敗しました。エラー: [_2]',
    'Send test webhook' => 'テストWebhook送信',
    'Sending...' => '送信中...',
    'Success!' => '成功！',
    'Failed!' => '失敗！',
    'Error!' => 'エラー！',
    'Sent to [_1] of [_2] URLs' => '[_2]個のURLのうち[_1]個に送信成功',
    'Save Changes' => '変更を保存',
    'HTTP request timeout in seconds' => 'HTTPリクエストのタイムアウト（秒）',
    'Number of retry attempts on failure' => '失敗時のリトライ回数',
    'Check to enable webhook notifications when content data is saved' => 'コンテンツデータ保存時のWebhook通知を有効にする',
    'Send a test webhook to verify configuration' => '設定確認のためのテストWebhookを送信',
);

1;
