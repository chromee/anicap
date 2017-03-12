class Picture < ActiveRecord::Base
  attr_accessor :content_type, :original_filename, :image_data
  before_save :decode_base64_image

   # photoをattachファイルとする。stylesで画像サイズを定義できる
  has_attached_file :photo, 
  :styles => { large:"1000x1000",medium: "300x300>" },
  :url  => "/assets/arts/:id/:style/:basename.:extension", # 画像保存先のURL先
	:path => "#{Rails.root}/public/assets/arts/:id/:style/:basename.:extension" # サーバ上の画像保存先パス
  
  validates_attachment :photo, 
  # presence: true,
  less_than: 5.megabytes, # ファイルサイズのチェック
  content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
                  
  acts_as_ordered_taggable_on :tags

  protected
    def decode_base64_image
      if image_data && content_type && original_filename
        decoded_data = Base64.decode64(image_data)

        data = StringIO.new(decoded_data)
        data.class_eval do
          attr_accessor :content_type, :original_filename
        end

        data.content_type = content_type
        data.original_filename = File.basename(original_filename)

        self.image = data
      end
    end
end
