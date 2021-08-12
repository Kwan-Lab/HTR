function head_twitch_preview

v = videoinput('gige', 1, 'Mono8');
preview(v)
pause
closepreview(v)


delete(v);
close all
clear global

