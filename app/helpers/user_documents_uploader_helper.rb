module UserDocumentsUploaderHelper
  def user_documents_uploader user
    documents_containers = user.documents_list.map do |document|      
      content_tag :div, class: 'u-marginbottom-20',
        data: { document_uploader: true } do
          concat label_tag(User.human_attribute_name(document))

          concat hidden_field_tag "user[#{document}]", user.send(document),
            data: { document_field: true }

          concat uploder_form(user.id, document)
          concat download_link(user, document) if user.send(document).present?
      end
    end

    documents_containers.join.html_safe
  end

  private

  def uploder_form user_id, document
    s3_uploader_form data: { s3_uploader: true },
      key: "uploads/user/#{document}/#{user_id}/${filename}" do
        file_field_tag :file, id: "user[#{document}]",
          data: { url: s3_uploader_url }
    end
  end

  def download_link user, document
    link_to user.send(document), target: '_blank' do
      concat image_tag('download-icon.png')
      concat t(:download_file)
    end
  end
end
