function print(obj,varargin)
  % Update and display the textToDisplay property.
  % The only optional argument is a new value for the text property.

  if nargin == 2
    obj.text = varargin{1};
  end

  obj.updateTextToDisplay();
  newPrintLength = fprintf([obj.getFormerTextPrintableDeleter() obj.textToDisplay]);

  obj.lastPrintLength = newPrintLength - obj.lastPrintLength;
end