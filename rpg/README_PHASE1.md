# Phase 1: RPG プロジェクト基盤

## 構成

このプロジェクトは、新規2D RPG開発用の基盤です。

### ディレクトリ構成

```
rpg/
├── scenes/              # シーン
│   ├── main.tscn        # メインシーン（タイトル画面から起動）
│   ├── title/           # タイトル画面
│   ├── maps/            # マップシーン
│   ├── battle/          # 戦闘シーン
│   └── ui/              # UI シーン
├── scripts/             # GDScript
│   ├── autoload/        # オートロード（Godot起動時に自動ロード）
│   ├── logic/           # ロジック層（RefCounted、テスト可能）
│   ├── world/           # マップ・移動関連
│   ├── battle/          # 戦闘関連
│   └── ui/              # UI関連
├── data/                # 外部データ（JSON）
│   ├── config/          # ゲーム設定
│   ├── characters/      # キャラクターデータ
│   ├── maps/            # マップメタデータ
│   ├── npcs/            # NPC定義
│   ├── dialogues/       # 会話スクリプト
│   ├── monsters/        # モンスターデータ
│   ├── weapons/         # 武器データ
│   ├── armors/          # 防具データ
│   ├── items/           # アイテムデータ
│   ├── shops/           # ショップデータ
│   ├── levels/          # レベルテーブル
│   ├── events/          # イベント定義
│   ├── skills/          # スキル定義
│   ├── spells/          # 魔法定義
│   ├── audio/           # 音声IDマッピング
│   └── ui/              # UI文言
├── assets/              # アセット
│   ├── characters/      # キャラクターグラフィック
│   ├── tilesets/        # タイルセット
│   ├── ui/              # UI画像・テーマ
│   ├── audio/           # 音声ファイル
│   │   ├── bgm/         # BGM
│   │   └── se/          # SE
│   └── _placeholder/    # 仮素材
└── tests/               # テスト
```

## 完成状況

### Phase 1: 基盤構築 ✅ 完了

- [x] Godot プロジェクト設定（4.7.2対応）
- [x] InputMap定義（WASD、矢印キー、決定、キャンセル、メニュー）
- [x] ウィンドウサイズ設定（1280×960、整数倍スケール）
- [x] Autoload構築
  - [x] Config（設定ローダー）
  - [x] Db（JSONデータベース）
  - [x] GameState（ゲーム状態管理）
  - [x] EventBus（シグナル）
  - [x] Flow（ゲームモード管理）
  - [x] SaveManager（セーブ機構の骨組み）
- [x] ロジック層
  - [x] BattleCalc（ダメージ計算・クリティカル・ミス・逃走）
  - [x] ConditionEvaluator（条件評価）
- [x] UI/タイトル画面
  - [x] theme.tres（テーマリソース）
  - [x] title_screen.gd（タイトル画面スクリプト）
  - [x] title_screen.tscn（タイトル画面シーン）
- [x] 初期データ
  - [x] data/config/game.json
  - [x] data/config/battle.json
  - [x] data/characters/hero.json
  - [x] data/ui/strings.json
  - [x] data/audio/audio.json
- [x] ドキュメント
  - [x] docs/SPEC.md
  - [x] docs/DATA_SCHEMA.md
  - [x] docs/DECISIONS.md
  - [x] docs/rpg_spec_v0.2.md（仕様書本体）
- [x] テスト・検証
  - [x] tools/validate_data.gd（データ検証）
  - [x] tests/run_all.gd（ロジック層テスト）

## テスト結果

```bash
# データ検証（ヘッドレス）
"/Applications/Godot.app/Contents/MacOS/Godot" --headless --path . --script rpg/tools/validate_data.gd
→ Expected: 成功（6ファイル検証完了）

# ロジック層テスト（ヘッドレス）
"/Applications/Godot.app/Contents/MacOS/Godot" --headless --path . --script rpg/tests/run_all.gd
→ Expected: 成功（全テストパス）
```

## 次のPhase（Phase 2）

### Phase 2: プレイヤー移動・マップシステム

実装内容:
- プレイヤーキャラクター
  - スプライト（32×32px、4方向アニメーション）
  - 移動スクリプト（WASD・矢印キー、1マス単位、移動中の入力バッファ）
  - 向き管理（up/down/left/right）
- マップシステム
  - TileMapLayer基盤
  - グリッド座標管理
  - 通行可否判定（カスタムデータレイヤー `walkable`）
  - NPC・宝箱の占有マス管理
- 初期マップ
  - `village.tscn`（村マップ）
  - `field.tscn`（フィールド）
  - `demon_castle.tscn`（魔王城）
- スクリプト
  - `scripts/world/grid_world.gd`（グリッド管理）
  - `scripts/world/player_controller.gd`（プレイヤー移動）
  - `scripts/world/map_manager.gd`（マップ管理）
- テスト
  - プレイヤー移動テスト
  - マップ遷移テスト
  - 壁衝突判定テスト

完了条件:
- WASD と矢印キーで1マス単位で移動できる
- 斜め移動が禁止される
- 壁・建物・水に衝突する
- 村 ⇔ フィールドでマップ遷移できる

---

**次に進む前に、Phase 1の状態をユーザーに報告します。**
