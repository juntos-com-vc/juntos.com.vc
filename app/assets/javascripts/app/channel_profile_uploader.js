App.addChild('ChannelProfileUploader', {
  el: '[data-channel-profile-upload]',

  events: {
    's3_upload_complete': 'uploadCompleted'
  },

  activate: function () {
    this.$el.find('[data-s3-uploader]').S3Uploader();
  },

  uploadCompleted: function (e, content) {
    $(e.target).siblings('[data-image-field]').val(content.url);
  }
});
