class AddPreviousAttachmentToTransparencyReports < ActiveRecord::Migration
  def change
    add_column :transparency_reports, :previous_attachment, :text
  end
end
