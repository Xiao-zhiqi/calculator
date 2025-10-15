interface Operator {
  symbol: string;
  precedence: number;
  operation: (a: number, b: number) => number;
}

const operators: Operator[] = [
  { symbol: '+', precedence: 1, operation: (a, b) => a + b },
  { symbol: '-', precedence: 1, operation: (a, b) => a - b },
  { symbol: '×', precedence: 2, operation: (a, b) => a * b },
  { symbol: '÷', precedence: 2, operation: (a, b) => a / b }
];

function Cal(expression: string): number {
  const tokens = expression.split(' ');
  const operandStack: number[] = [];
  const operatorStack: Operator[] = [];

  for (const token of tokens) {
    if (!isNaN(Number(token))) {
      operandStack.push(Number(token));
    } else {

      const currentOperator = operators.find(op => op.symbol === token);
      if (currentOperator) {
        while (operatorStack.length > 0 && operatorStack[operatorStack.length - 1].precedence >= currentOperator.precedence) {
          const op = operatorStack.pop()!;
          const b = operandStack.pop()!;
          const a = operandStack.pop()!;
          operandStack.push(op.operation(a, b));
        }
        operatorStack.push(currentOperator);
      }
    }
  }

  while (operatorStack.length > 0) {
    const op = operatorStack.pop()!;
    const b = operandStack.pop()!;
    const a = operandStack.pop()!;
    operandStack.push(op.operation(a, b));
  }

  return operandStack.pop()!;
}
