class Comments {
  final _pcof_id;
  final _pcof_pcm_id;
  final _commentator;
  final _comm_email;
  final _comment;
  final _comment_time;

  Comments(this._pcof_id, this._pcof_pcm_id, this._commentator,
      this._comm_email, this._comment, this._comment_time);

  get comment_time => _comment_time;

  get comment => _comment;

  get comm_email => _comm_email;

  get commentator => _commentator;

  get pcof_pcm_id => _pcof_pcm_id;

  get pcof_id => _pcof_id;
}
