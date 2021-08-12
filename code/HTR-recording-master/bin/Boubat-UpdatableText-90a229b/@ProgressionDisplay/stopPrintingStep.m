function stopPrintingStep(obj)
  % Remove the stepText from the displayed text.

  obj.stepTextIsPrinted = false;
  obj.print();
end