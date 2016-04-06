class User::FixUsersDocumentsURLService
  def self.process
    User.find_each do |user|
      user.update_attributes({
        original_doc1_url: user.doc1.url,
        original_doc2_url: user.doc2.url,
        original_doc3_url: user.doc3.url,
        original_doc4_url: user.doc4.url,
        original_doc5_url: user.doc5.url,
        original_doc6_url: user.doc6.url,
        original_doc7_url: user.doc7.url,
        original_doc8_url: user.doc8.url,
        original_doc9_url: user.doc9.url,
        original_doc10_url: user.doc10.url,
        original_doc11_url: user.doc11.url,
        original_doc12_url: user.doc12.url,
        original_doc13_url: user.doc13.url
      })
    end
  end
end
