# サブ課題 - インスタグラム開発

Instagramのコピーサイトです。ポテパンキャンプのサブ課題の成果物として作成しました。

**機能要件**  
*ログイン機能 / ユーザー登録機能  
*Facebookを使ったログイン機能  
  *deviseを使わずにOAuth 2.0のみ使用して実装  
*プロフィール変更機能  
*投稿機能  
*ユーザーのフォロー機能  
*投稿へのコメント投稿機能  
*お気に入り機能  
  *投稿の右上のブックマークアイコンを押すことで投稿をお気に入りに追加することが可能）  
*通知機能  
  *他ユーザーからフォローされた場合、自分の投稿にコメントやブックマークがあった場合に通知が表示される）  
*写真検索機能  
  *検索フォームにワードを入力して検索し、該当するワードが含まれる投稿を表示可能）  

**※要改善ポイント**  
*deviseを使った認証機能の実装ができていない点。
  *今回はrailsチュートリアルの流れに沿って認証機能を実装したためdeviseは使わず。  
*ブックマークボタンのAjax化ができていない点。  
*micropostのモーダルからのお気に入り、コメント、等の動的なアクションができない点。  