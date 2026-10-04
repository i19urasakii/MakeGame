# DATA_SCHEMA.md

このドキュメントは、フェーズ 1 における最小限の JSON スキーマを定義する。

## 1. config

- `data/config/game.json`
- `data/config/battle.json`

必要キー:
- `id`: 文字列
- 追加項目は各ファイルごとに定義する

例:
```json
{
  "id": "game",
  "tile_size": 32,
  "move_time_sec": 0.15,
  "text_speed": 30,
  "start_gold": 50
}
```

## 2. ui

- `data/ui/strings.json`

必要キー:
- `id`: 文字列
- `title`: タイトル文言
- `subtitle`: サブタイトル文言
- `start_game`: スタートボタン文言

## 3. audio

- `data/audio/audio.json`

必要キー:
- `id`: 文字列
- `bgm`: BGM ID の辞書
- `se`: SE ID の辞書

## 4. characters

- `data/characters/hero.json`

必要キー:
- `id`: 文字列
- `name`: 文字列
- `start`: 初期値オブジェクト

## 5. ルール

- JSON は UTF-8 で保存する
- `id` は `snake_case` の文字列とする
- 変更時は `tools/validate_data.gd` を実行し、エラーがなければ OK とする
