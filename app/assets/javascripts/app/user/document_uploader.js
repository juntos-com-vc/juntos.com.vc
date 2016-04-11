App.addChild('DocumentUploader', {
  el: '[data-document-uploader]',

  events: {
    's3_upload_complete': 'updateUploadField'
  },

  activate: function () {
    this.$el.find('[data-s3-uploader]').S3Uploader();
  },

  updateUploadField: function (e, content) {
    $(e.currentTarget).find('[data-document-field]').val(content.url);
  }
});
