//JAVASCRIPT CODE GOES HERE
$('#join-form').on('submit', (event) => {
  event.preventDefault();

  let formAction = $('#join-form').attr('action');
  let meetupId = formAction.substring(formAction.lastIndexOf('/')+1);

  let username = '';
  let avatar_url = '';
  let id = '';

  let request = $.ajax({
    method: 'POST',
    dataType: 'json',
    data: { meetup_id: meetupId },
    url: '/api/v1/meetups.json',
    accepts: 'application/json',
    success: function(data) {
      id = data.id;
      username = data.name;
      avatar_url = data.avatar_url;
    },
    error: function() {
      alert("You must sign in first!");
    }
  });

  request.done(() => {
    let htmlStr = `<img src="${avatar_url}" height="42" width="42"> ${username}`;
    $('ul.members').append('<li id=' + id + '>' + htmlStr + '</li>');

    $('#join-div').empty();
    addDeleteForm(meetupId);
  });
});

$('#delete-form').on('submit', (event) => {
  event.preventDefault();

  let formAction = $('#delete-form').attr('action');
  let meetupId = formAction.substring(formAction.lastIndexOf('/')+1);

  let id = '';

  let request = $.ajax({
    method: 'POST',
    dataType: 'json',
    data: { meetup_id: meetupId },
    url: '/api/v1/meetups/leave.json',
    accepts: 'application/json',
    success: function(data) {
      id = data.id;
    },
    error: function() {
      alert("Error in leaving!");
    }
  });

  request.done(() => {
    $('ul.members > li#' + id ).remove();

    $('#leave-div').empty();
    addJoinForm(meetupId);
  });
});

let addDeleteForm = (id) => {
  let delForm ='<form action="/meetups/leave/' + id + '" id="delete-form" method="post">';
  delForm += '<input type="submit" id="leave" value="Leave"></form>';

  $('#leave-div').append(delForm);
};

let addJoinForm = (id) => {
  let joinForm = '<form action="/meetups/' + id + '" id="join-form" method="post">';
  joinForm += '<input type="submit" id="join" value="Join"></form>';

  $('#join-div').append(joinForm);
};
