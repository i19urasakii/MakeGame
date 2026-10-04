# CLAUDE.md

2D 見下ろし型・ターン制コマンド RPG（Godot 4.7 / GDScript）。
**エンジン部分と初期コンテンツを分離し、コンテンツをデータで追加できること**が最重要要件。

## 必読ドキュメント

作業前に必ず読む。

- `docs/SPEC.md` — 開発仕様（既定値・ゲームルール・初期データ・フェーズと完了条件）
- `docs/DATA_SCHEMA.md` — 各 JSON のスキーマ（フェーズ 1 で作成。以後データを変えたら同期する）
- `docs/DECISIONS.md` — 実装中の判断記録

仕様と実装が食い違う場合は、勝手にどちらかを選ばず、質問してから `docs/DECISIONS.md` に記録する。

## 現在のフェーズ

フェーズ 1（基盤）: 未着手

フェーズの完了条件は `docs/SPEC.md` §20 にある。条件を満たしたらこの行を更新し、コミットする。

## コマンド

Godot 実行ファイルは `godot` として呼べる前提。パスが通っていない場合は、環境に合わせてここを書き換える。

```
# データ検証（データ変更後は必ず実行。エラーがあれば終了コード非 0）
godot --headless --path . --script tools/validate_data.gd

# ロジック層のテスト（フェーズ 1 で tests/run_all.gd を作成する）
godot --headless --path . --script tests/run_all.gd

# スモークテスト（エラーなく起動できること）
godot --headless --path . --quit-after 60

# バランスシミュレーション（フェーズ 6 以降）
godot --headless --path . --script tools/balance_sim.gd
```

作業を終えたと報告する前に、**検証・テスト・スモークテストをすべて実行して結果を確認する**。実行できない場合は、その旨と理由を明示する。

## ディレクトリ

```
assets/    素材（characters, tilesets, backgrounds, ui, items, effects, fonts, audio, _placeholder）
data/      ゲームデータ（JSON）。maps, npcs, dialogues, monsters, skills, spells,
           items, weapons, armors, shops, levels, events, characters, config, ui, audio
scenes/    シーン（maps, world, battle, ui, title）
scripts/   autoload/, logic/, world/, battle/, ui/
tools/     validate_data.gd, balance_sim.gd
tests/     ロジック層のテスト
docs/      SPEC.md, DATA_SCHEMA.md, DECISIONS.md
```

## ハードコード禁止

次の内容は**スクリプトに直接書かない**。必ず `data/` の JSON または `Config` から読み込む。

- NPC の会話内容、UI 文言（`data/ui/strings.json`）
- モンスターのステータス、経験値、ゴールド
- レベルごとの必要経験値・ステータス
- 武器・防具・アイテムの価格と効果、ショップの商品
- マップの配置（NPC・遷移・宝箱・出現テーブル）、エンカウント率
- イベントの条件と内容
- タイルサイズ・移動速度・文字送り速度などの定数（`data/config/*.json`）
- 音 ID とファイルの対応（`data/audio/audio.json`）
- キー入力（InputMap のアクション名で扱う）

新しい数値や文言が必要になったら、まずデータ側に置き場所を作る。

## 設計ルール

- **状態の置き場は `GameState` のみ**。プレイヤー・所持品・装備・フラグ・現在地・宝箱の開封状態・プレイ時間は、すべてここに集約する（セーブ対象）。
- **ロジック層は Node に依存させない**。ダメージ計算、レベル判定、ステータス算出、条件評価、エンカウント抽選、セーブ変換は `scripts/logic/` に `RefCounted` として置き、乱数（`RandomNumberGenerator`）は外から注入できるようにする。
- UI とゲームロジックの連携は `EventBus` のシグナルで行う。直接参照で結合しない。
- 会話・イベント・宝箱・ショップは、共通の**条件**（`ConditionEvaluator`）と**アクション**（`ActionRunner`）を使う。個別に専用の判定処理を作らない。
- ID は `snake_case` の文字列。座標は `(x, y)`、原点は左上、y は下向きが正。
- 移動判定は物理コリジョンではなく `GridWorld`（タイルの `walkable` + 占有マス）で行う。
- マップは `TileMapLayer`（`TileMap` は使わない）。メタ情報は `data/maps/*.json`。
- 素材は `AssetLoader.texture(path)` 経由で取得する。存在しない場合は `assets/_placeholder/` の仮素材を返し、クラッシュさせない。音源がなくてもクラッシュさせない。
- ファイルの書き込みは `user://` 以下のみ。セーブはアトミックに書く（一時ファイル → リネーム）。

## コーディング規約

- GDScript は静的型付け。`class_name` を付け、1 ファイル 1 責務。
- 命名: 変数・関数・ファイル名は `snake_case`、クラス名は `PascalCase`、定数は `UPPER_SNAKE_CASE`。
- Godot 4.7 で非推奨・廃止の API を使わない（`TileMap`、旧形式の `yield`、文字列での `connect` など）。API に自信がない場合は公式ドキュメントで確認する。
- マジックナンバーを書かない。必要なら `Config` またはデータに出す。
- 日本語フォントは `assets/fonts/` に同梱したものを使い、システムフォントに依存しない。
- コメントは「なぜそうするか」を書く。処理の言い換えは書かない。

## データを追加・変更するとき

1. `docs/DATA_SCHEMA.md` のスキーマに従って JSON を書く。
2. `validate_data` を実行し、エラーがないことを確認する。
3. スキーマを変えた場合は `docs/DATA_SCHEMA.md` と `tools/validate_data.gd` を同時に更新する。
4. セーブデータに影響する場合は `save_version` を上げ、`migrate()` を用意する。

「JSON を 1 つ追加するだけで敵・NPC・会話・マップ・装備が増やせる」状態を常に保つ。コード変更が必要になったら、それは設計の見直しサインとして `docs/DECISIONS.md` に記録する。

## 作業の進め方

- **1 フェーズ = 1 セッション = 1 コミット**を目安にする。フェーズを飛ばさない。
- 着手前に、そのフェーズの作業内容と完了条件を `docs/SPEC.md` §20 で確認し、要点を短く復唱してから始める。
- 大きな変更（Autoload の追加、データ形式の変更、アドオンの導入）は、実装前に方針を説明して確認を取る。
- 仕様にない判断で迷ったら質問する。決まった内容は `docs/DECISIONS.md` に日付つきで記録する。
- 本書や `docs/SPEC.md` の既定値を変える場合は、黙って変更せず理由を `docs/DECISIONS.md` に記録する。
- コミットメッセージは「フェーズ番号: 内容」の形式にする（例: `P2: 1マス移動とマップ遷移を実装`）。

## やってはいけないこと

- 特定作品（ドラゴンクエスト等）の画像・音声・フォント・キャラクター名・呪文名・固有の文言を使わない。UI やゲームの雰囲気を参考にするのは良いが、すべてオリジナルで実装する。
- 依頼されていないフェーズの機能を先取りして作り込まない（ただし、データ構造を拡張可能にしておくのは良い）。
- テストや検証を通すためだけに、検証側を緩めたりテストを削除したりしない。
- AI 生成素材や外部素材を、ライセンス・利用規約を確認せずに追加しない。
