use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Poll;

class GStreamr::Poll {
  has GstPoll $!p;

  submethod BUILD (:$poll) {
    $!p = $poll;
  }

  method GStreamer::Raw::Definitions::GstPoll
    is also<GstPoll>
  { $!p }

  method new (Int() $controllable) {
    my gboolean $c = $controllable.so.Int;
    my $poll = gst_poll_new($c);

    $poll ?? self.bless( :$poll ) !! Nil;
  }

  method new_timer is also<new-timer> {
    my $poll = gst_poll_new_timer();

    $poll ?? self.bless( :$poll ) !! Nil;
  }

  method add_fd (GstPollFD() $fd) is also<add-fd> {
    so gst_poll_add_fd($!p, $fd);
  }

  method free {
    gst_poll_free($!p);
  }

  # Is FD an out param?
  method get_read_gpollfd (GPollFD() $fd) is also<get-read-gpollfd> {
    gst_poll_get_read_gpollfd($!p, $fd);
  }

  method read_control is also<read-control> {
    so gst_poll_read_control($!p);
  }

  method remove_fd (GstPollFD $fd) is also<remove-fd> {
    so gst_poll_remove_fd($!p, $fd);
  }

  method restart {
    gst_poll_restart($!p);
  }

  method set_controllable (Int() $controllable) is also<set-controllable> {
    my gboolean $c = $controllable.so.Int;

    so gst_poll_set_controllable($!p, $c);
  }

  method set_flushing (Int() $flushing) is also<set-flushing> {
    my gboolean $f = $flushing.so.Int;

    gst_poll_set_flushing($!p, $f);
  }

  method wait (Int() $timeout) {
    my GstClockTime $t = $timeout;

    gst_poll_wait($!p, $t);
  }

  method write_control is also<write-control> {
    so gst_poll_write_control($!p);
  }

}

class GStreamer::Poll::FD {
  has GstPoll $!poll;
  has GstPollFD $!pfd;

  submethod BUILD (:$poll, :$poll-fd) {
    $!poll = $poll;
    $!pfd = $poll-fd // GstPollFD.new;
  }

  method GStreamer::Raw::Definitions::GstPoll
    is also<GstPoll>
  { $!poll }

  method GStreamer::Raw::Stucts::GstPollFD
    is also<GstPollFD>
  { $!pfd }

  multi method new (GstPoll() $poll, GstPollFD $poll-fd) {
    $poll-fd && $poll ?? self.bless( :$poll-fd, :$poll ) !! Nil;
  }
  multi method new (GstPoll() $poll) {
    $poll ?? self.bless( :$poll ) !! Nil
  }

  method can_read is also<can-read> {
    so gst_poll_fd_can_read($!poll, $!pfd);
  }

  method can_write is also<can-write> {
    so gst_poll_fd_can_write($!poll, $!pfd);
  }

  method ctl_pri (Int() $active) is also<ctl-pri> {
    my gboolean $a = $active.so.Int;

    so gst_poll_fd_ctl_pri($!poll, $!pfd, $a);
  }

  method ctl_read (Int() $active) is also<ctl-read> {
    my gboolean $a = $active.so.Int;

    so gst_poll_fd_ctl_read($!poll, $!pfd, $active);
  }

  method ctl_write (Int() $active) is also<ctl-write> {
    my gboolean $a = $active.so.Int;

    so gst_poll_fd_ctl_write($!poll, $!pfd, $active);
  }

  method has_closed is also<has-closed> {
    so gst_poll_fd_has_closed($!poll, $!pfd);
  }

  method has_error is also<has-error> {
    so gst_poll_fd_has_error($!poll, $!pfd);
  }

  method has_pri is also<has-pri> {
    so gst_poll_fd_has_pri($!poll, $!pfd);
  }

  method ignored {
    gst_poll_fd_ignored($!poll, $!pfd);
  }

  multi method init {
    GStreamer::Poll::FD.init($!pfd)
  }
  multi method init ( GStreamer::Poll::FD:U: GstPollFD $poll-fd) {
    gst_poll_fd_init($poll-fd);
  }

}
