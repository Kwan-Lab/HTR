function output = getFormerTextPrintableDeleter(obj)
  % The special character \b (backspace) allow the whole updatable text feature.
  % If printed, it deletes the former characters.

  output = repmat('\b',1,obj.lastPrintLength);
end