greetings();
UpdatableTextDemo();
ProgressionDisplayDemo();

function greetings()
  greetings = UpdatableText;
  welcomeMessage = 'This demo is about to start';
  for i = 1:length(welcomeMessage)
    greetings.print(welcomeMessage(1:i));
    pause(0.05);
  end
  pause(1);
  for i = 1:length(welcomeMessage)
    greetings.print(welcomeMessage(1:end-i));
    pause(0.05);
  end
  greetings.erase();
end

function UpdatableTextDemo()
  fprintf('Let''s try the UpdatableText class:\n\n');
  pause(2);

  demoText = UpdatableText;
  textsToShow = {'This','is','a','basic','updatable','text'};
  for text = textsToShow
    demoText.print(text{1});
    pause(0.6);
  end
  
  demoText.setPrefix('PREFIX ');
  demoText.print('now with a prefix');
  pause(2.5);
  
  demoText.setSuffix(' SUFFIX\n');
  demoText.print('now with a suffix');
  pause(2.5);

  demoText.erase();
  demoText = UpdatableText('PREFIX ',' SUFFIX\n');
  demoText.print('prefix and suffix can be given to the UpdatableText constructor');
  pause(5);
  
  demoText.setPrefix('PREFIX');
  demoText.setSuffix('SUFFIX');
  demoText.setFormatString('_prefix _text _suffix\n');
  demoText.print('you can change the format string');
  pause(2.5);
  demoText.setFormatString('_suffix _text _prefix\n');
  pause(1);
  demoText.setFormatString('_prefix _text _suffix\n');
  pause(1);
  demoText.setFormatString('_suffix _text _prefix\n');
  pause(1);
  demoText.setFormatString('_prefix _text _suffix\n');
  pause(1);
  demoText.print('like you want');
  pause(2.5);
  demoText.setFormatString('_text _prefix _suffix\n');
  pause(1);
  demoText.setFormatString('_text _prefix _suffix_suffix\n');
  pause(1);
  demoText.setFormatString('_text _prefix_prefix _suffix_suffix\n');
  pause(1);
  demoText.setFormatString('_text _text _prefix_prefix _suffix_suffix\n');
  pause(1);
  demoText.setFormatString('_text _text        _prefix_prefix _suffix_suffix\n');
  pause(1);
  demoText.setFormatString('_prefix _text _suffix\n');
  demoText.print('back to normal');
  pause(2.5);

  demoText.print('you can also print lines above');
  pause(2.5);
  demoText.printAbove('This line has been printed above...');
  pause(2.5);
  demoText.printAbove('... and another line printed above.');
  pause(2.5);
  demoText.erase();
  fprintf('End of basic UpdatableText demonstration.\n');
  pause(3);
end

function ProgressionDisplayDemo()
  fprintf('\nLet''s try the ProgressionDisplay class:\n\n');
  pause(2);
  
  progression = ProgressionDisplay;
  
  progression.print('Showing steps:');
  progression.startPrintingStep();
  demoLoop(progression);
  
  progression.print('Showing percent:');
  progression.stopPrintingStep();
  progression.startPrintingPercent();
  demoLoop(progression);
  
  progression.print('Showing progress bar:');
  progression.stopPrintingPercent();
  progression.startPrintingProgressBar();
  demoLoop(progression);
  
  progression.print('Resized progress bar:');
  progression.setProgressBarLength(50);
  demoLoop(progression);
  progression.setProgressBarLength(20);
  
  progression.print('Showing all:');
  progression.startPrintingPercent();
  progression.startPrintingStep();
  demoLoop(progression);
  
  progression.setProgressBarLength(4);
  progression.print('Playing with format string:');
  progression.setFormatString('_text _step _progressbar_percent_progressbar_percent_progressbar_percent_progressbar_percent_progressbar\n')
  demoLoop(progression);
  pause(2.5);

  progression.erase();
  fprintf('End of ProgressionDisplay demonstration.\n');
end

function demoLoop(progressionDisplay)
  maxStep = 400;
  pauseLength = 0.01;
  for i = 0:maxStep
    progressionDisplay.updateStep(i,maxStep);
    pause(pauseLength);
  end
end