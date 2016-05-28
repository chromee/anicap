class Picture < ActiveRecord::Base
   # photoをattachファイルとする。stylesで画像サイズを定義できる
  has_attached_file :photo, 
  :styles => { large:"1000x1000",medium: "300x300>" },
  :url  => "/assets/arts/:id/:style/:basename.:extension", # 画像保存先のURL先
	:path => "#{Rails.root}/public/assets/arts/:id/:style/:basename.:extension" # サーバ上の画像保存先パス
  
  validates_attachment :photo, 
  presence: true,  # ファイルの存在チェック
      less_than: 5.megabytes, # ファイルサイズのチェック
  content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
                  # ファイルの拡張子を指定（これがないとエラーが発生する）
                  
  acts_as_ordered_taggable_on :tags
end
