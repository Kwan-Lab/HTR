function output = updateTextToDisplay(obj)
  obj.textToDisplay = obj.formatString;
  cellfun(@(formatFunction)formatFunction(obj),obj.formatFunctions);
end