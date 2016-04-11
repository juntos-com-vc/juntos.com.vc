App.ProjectCoverUploader = {
  submitButton: $('.js-btn-submit'),

  events: {
    's3_upload_complete': 'uploadComplete',
    's3_uploads_start': 'toggleSubmitButton',
    's3_uploads_complete': 'toggleSubmitButton'
  },

  activate: function () {
    this.$el.find('[data-s3-uploader]').S3Uploader({
      remove_completed_progress_bar: false
    });
  },

  uploadComplete: function (e, content) {
    this.$el.find('[data-image-field]').val(content.url);

    if (this.previewImage) {
      $(this.previewImage).attr('src', content.url);
    }
  },

  toggleSubmitButton: function (e) {
    this.submitButton.attr('disabled', function (index, attr) {
      return !attr;
    });
  }
};
