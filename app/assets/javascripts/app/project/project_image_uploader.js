App.ProjectImageUploader = {
  submitButton: $('.js-btn-submit'),

  events: {
    's3_upload_complete': 'uploadComplete',
    's3_uploads_start': 'toggleSubmitButton',
    's3_uploads_complete': 'toggleSubmitButton',
    'click [data-remove-image]': 'removeImage'
  },

  activate: function () {
    this.$el.find('[data-s3-uploader]').S3Uploader();
  },

  onLimit: function () {
    return this.limit && (this.limit > this.thumbCount());
  },

  thumbCount: function () {
    return this.thumbGallery.children().length;
  },

  uploadComplete: function (e, content) {
    var thumb = this.template({ url: content.url });

    if (this.onLimit()) {
      this.thumbGallery.append(thumb);
    } else {
      this.disableFileInput(true);
    }
  },

  toggleSubmitButton: function (e) {
    this.submitButton.attr('disabled', function (index, attr) {
      return !attr;
    });
  },

  disableFileInput: function (attrValue) {
    this.$el.find('input[type=file]').attr('disabled', attrValue);
  },

  removeImage: function (e) {
    e.preventDefault();
    e.currentTarget.closest('[data-thumbnail-card]').remove();
    this.disableFileInput(!this.onLimit());
  }
}
