# Content Webhook Plugin

MovableTypeのコンテンツデータが保存・削除されたときに、設定されたURLに対してWebhook通知を送信するプラグインです。

## 機能

- コンテンツデータの保存・削除時に指定されたWebhook URLへ通知を送信
- システム設定画面でWebhook URLを設定可能

## インストール

1. プラグインファイルをMovableTypeのpluginsディレクトリに配置
2. MovableTypeの管理画面にログイン
3. システム > プラグインでプラグインが有効になっていることを確認

## 設定方法

1. MovableTypeの管理画面にログイン
2. システム > プラグイン > Content Webhook の「設定」をクリック
3. Webhook URLを入力（例：https://example.com/webhook）
4. 「変更を保存」をクリック

## 送信データ形式

Webhookで送信されるJSONデータの形式：

### コンテンツデータ保存時

```json
{
  "event": "content_data.saved",
  "timestamp": "2025-01-25T19:53:00Z",
  "data": {
    "type": "コンテンツタイプ名",
    "id": 123
  }
}
```

### コンテンツデータ削除時

```json
{
  "event": "content_data.deleted",
  "timestamp": "2025-01-25T19:53:00Z",
  "data": {
    "type": "コンテンツタイプ名",
    "id": 123
  }
}
```

### フィールド説明

- `event`: イベントタイプ
  - `content_data.saved`: コンテンツデータ保存時
  - `content_data.deleted`: コンテンツデータ削除時
- `timestamp`: Webhook送信時刻（ISO8601形式）
- `data.type`: コンテンツタイプの名前
- `data.id`: コンテンツデータのID

## 動作条件

- Webhook URLが設定されている場合のみ動作
- 有効なHTTP/HTTPS URLが設定されている場合のみ送信

## トラブルシューティング

### Webhookが送信されない場合

1. プラグインが有効になっているか確認
2. Webhook URLが正しく設定されているか確認（http://またはhttps://で始まる）
3. 送信先サーバーがアクセス可能か確認

## 技術仕様

- **対応MT版本**: MovableType 7.x以降
- **必要モジュール**: LWP::UserAgent, JSON
- **HTTP メソッド**: POST
- **Content-Type**: application/json
- **User-Agent**: MovableType-ContentWebhook/1.0

## ファイル構成

```
mt/cms/plugins/ContentWebhook/
├── config.yaml                    # プラグイン設定
├── lib/
│   └── ContentWebhook/
│       ├── Callback.pm           # コールバック処理
│       ├── CMS.pm               # 管理画面処理
│       ├── L10N.pm              # 多言語対応基底クラス
│       └── L10N/
│           └── ja.pm            # 日本語リソース
├── tmpl/
│   └── system_config.tmpl       # システム設定画面
└── README.md                    # このファイル
```

## 更新履歴

- v1.0.0: 初回リリース
  - コンテンツデータ保存・削除時のWebhook送信機能
  - システム設定画面
