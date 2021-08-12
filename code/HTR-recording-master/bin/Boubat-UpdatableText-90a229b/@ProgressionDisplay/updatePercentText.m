function updatePercentText(obj)
  % Percent text looks like: ' (75.00%)'
  % with a progressFraction = 0.75.

  if not(obj.percentTextIsPrinted)
    obj.percentText = '';
    return
  end

  obj.percentText = [ ' (' sprintf('%.2f',100*obj.progressFraction) '%%)'];
end