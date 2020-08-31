# サブ課題 - インスタグラム開発

Instagramのコピーサイトです。ポテパンキャンプのサブ課題の成果物として作成しました。  

**機能要件**  
1. ログイン機能 / ユーザー登録機能  
2. Facebookを使ったログイン機能  
  2. deviseを使わずにOAuth 2.0のみ使用して実装  
3. プロフィール変更機能  
4. 投稿機能  
5. ユーザーのフォロー機能  
6. 投稿へのコメント投稿機能  
7. お気に入り機能  
  7. 投稿の右上のブックマークアイコンを押すことで投稿をお気に入りに追加することが可能）  
8. 通知機能  
  8. 他ユーザーからフォローされた場合、自分の投稿にコメントやブックマークがあった場合に通知が表示される）  
9. 写真検索機能  
  9. 検索フォームにワードを入力して検索し、該当するワードが含まれる投稿を表示可能）  

**※要改善ポイント**  
1. deviseを使った認証機能の実装ができていない点。
  1. 今回はrailsチュートリアルの流れに沿って認証機能を実装したためdeviseは使わず。  
2. ブックマークボタンのAjax化ができていない点。  
3. micropostのモーダルからのお気に入り、コメント、等の動的なアクションができない点。  