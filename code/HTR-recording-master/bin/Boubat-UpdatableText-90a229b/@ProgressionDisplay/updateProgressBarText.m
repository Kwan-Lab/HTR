function updateProgressBarText(obj)
  % Progress bar text looks like: ' [===============     ]'
  % with a progressFraction = 0.75 and a progressBarLength = 20.

  if not(obj.progressBarIsPrinted)
    obj.progressBarText = '';
    return
  end
  
  numberOfProgressCharacters = fix(obj.progressBarLength*obj.progressFraction);
  obj.progressBarText = [' [',...
    repmat('=',1,numberOfProgressCharacters),...
    repmat(' ',1,obj.progressBarLength-numberOfProgressCharacters),...
    ']'];
end