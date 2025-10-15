//计算器//把π去掉。
import { Button1 } from './Button1'
import {Button2} from'./Button2'//定义两个按钮格式
// import {Cal}from'./cal'也可以将四则运算的函数定义到别处然后引入，这里为了方便直接放到这里了
class DoubleStackCalculatorWithParentheses {
  private operandStack: number[] = [];
  private operatorStack: string[] = [];

  calculate(expression: string): number {
    const tokens = this.tokenizeExpression(expression);
    for (const token of tokens) {
      if (/^-?\d+(\.\d+)?$/.test(token)) {  // 如果标记是一个数字（包括负数和小数），将其转换为数字类型并推入operandStack。
        this.operandStack.push(Number(token));
      } else if (token === '(') {
        this.operatorStack.push(token);
      } else if (token === ')') {//如果标记是右括号)，初始化结果变量result为 0，以及标记是否为负数的变量isNegative为 false。
        let result = 0;
        let isNegative = false;
        while (this.operatorStack.length > 0 && this.operatorStack[this.operatorStack.length - 1]!== '(') {
          const operator = this.operatorStack.pop()!;
          if (this.operandStack.length >= 2) {
            const operand2 = this.operandStack.pop()!;
            const operand1 = this.operandStack.pop()!;
//当operatorStack非空且栈顶不是左括号时，弹出一个操作符，并检查operandStack中是否有足够的操作数（至少两个）
            switch (operator) {
              case '+':
                result = operand1 + operand2;
                break;
              case '-':
                result = operand1 - operand2;
                isNegative = result < 0;  // 这里及时判断减法结果的正负
                break;
              case '×':
                result = operand1 * operand2;
                isNegative = result < 0;  // 乘法结果的正负
                break;
              case '%':
                if (operand2!== 0) {
                  result = operand1 % operand2;
                  isNegative = result < 0;  // 取余结果的正负
                } else {
                  throw new Error("取余运算，除数不能为 0");
                }
                break;
              case '÷':
                if (operand2!== 0) {
                  result = operand1 / operand2;
                  isNegative = result < 0;  // 除法结果的正负
                } else {
                  throw new Error("除数不能为 0");
                }
                break;
            }
            this.operandStack.push(result);
          } else {
            throw new Error("无效的表达式，运算数不足");
          }
        }//，将结果存入result，并根据结果的正负更新isNegative。如果除数为 0 则抛出错误。将结果推入operandStack。
        if (this.operatorStack.length > 0 && this.operatorStack[this.operatorStack.length - 1] === '(') {
          this.operatorStack.pop();
          if (this.operandStack.length > 0) {
            let operand = this.operandStack.pop()!;
            if (isNegative) {  // 根据之前保存的正负性进行处理
              operand = operand;
            }
            this.operandStack.push(operand);
          }
        }//如果operatorStack的栈顶是左括号，弹出左括号。如果operandStack非空，取出一个操作数，根据正负性进行处理后再推入operandStack。
      } else if (token.startsWith("（") && token.endsWith("）")) {  // 处理 "（X）" 形式,提取括号中的数字并推入operandStack。
        const operand = Number(token.slice(1, -1));
        this.operandStack.push(operand);
      } else if (token.startsWith("（") && token.endsWith("-")) {  // 处理 "（X）-" 形式
        let operand = 0;
        while (this.operatorStack.length > 0 && this.operatorStack[this.operatorStack.length - 1]!== '(') {
          const operator = this.operatorStack.pop()!;
          if (this.operandStack.length >= 2) {
            const operand2 = this.operandStack.pop()!;
            const operand1 = this.operandStack.pop()!;

            switch (operator) {
              case '+':
                operand = operand1 + operand2;
                break;
              case '-':
                operand = operand1 - operand2;
                break;
              case '×':
                operand = operand1 * operand2;
                break;
              case '%':
                if (operand2!== 0) {
                  operand = operand1 % operand2;
                } else {
                  throw new Error("取余运算，除数不能为 0");
                }
                break;
              case '÷':
                if (operand2!== 0) {
                  operand = operand1 / operand2;
                } else {
                  throw new Error("除数不能为 0");
                }
                break;
            }
          } else {
            throw new Error("无效的表达式，运算数不足");
          }
        }
        if (this.operatorStack.length > 0 && this.operatorStack[this.operatorStack.length - 1] === '(') {
          this.operatorStack.pop();
        }
        this.operandStack.push(operand);  // 不再取负，直接保留括号内计算结果
      } else {
        while (this.operatorStack.length > 0 && this.getPrecedence(token) <= this.getPrecedence(this.operatorStack[this.operatorStack.length - 1])) {
          this.performOperation();
        }
        this.operatorStack.push(token);
      }
    }//如果标记是其他操作符，在operatorStack中的操作符优先级不低于当前操作符时，进行操作。然后将当前操作符推入operatorStack。

    while (this.operatorStack.length > 0) {
      this.performOperation();
    }//当遍历完所有标记后，如果operatorStack中还有操作符，继续进行操作直到operatorStack为空。

    if (this.operandStack.length === 0) {
      throw new Error("无效的表达式，没有最终结果");
    }

    return this.operandStack.pop()!;
  }

  private performOperation(): void {
    if (this.operatorStack.length > 0) {
      const operator = this.operatorStack.pop()!;
      if (this.operandStack.length >= 2) {
        const operand2 = this.operandStack.pop()!;
        const operand1 = this.operandStack.pop()!;
//如果operatorStack非空，弹出一个操作符。如果operandStack中有足够的操作数（至少两个），弹出两个操作数。
        switch (operator) {
          case '+':
            this.operandStack.push(operand1 + operand2);
            break;
          case '-':
            this.operandStack.push(operand1 - operand2);
            break;
          case '×':
            this.operandStack.push(operand1 * operand2);
            break;
          case '%':
            if (operand2!== 0) {
              this.operandStack.push(operand1 % operand2);
            } else {
              throw new Error("取余运算，除数不能为 0");
            }
            break;
          case '÷':
            if (operand2!== 0) {
              this.operandStack.push(operand1 / operand2);
            } else {
              throw new Error("除数不能为 0");
            }
            break;
        }
      } else {
        throw new Error("无效的表达式，运算数不足");
      }
    } else {
      throw new Error("无效的表达式，运算符不足");
    }
  }

  private getPrecedence(operator: string): number {
    if (operator === '+' || operator === '-') {
      return 1;
    } else if (operator === '×' || operator === '÷' || operator === '%') {
      return 2;
    }
    return 0;
  }

  private tokenizeExpression(expression: string): string[] {
    const tokens: string[] = [];
    let currentToken = '';
    for (const char of expression) {
      if (/\d/.test(char) || (char === '-' && currentToken === '') || (char === '.' &&!currentToken.includes('.'))) {  // 处理负数起始和单个小数点的情况
        currentToken += char;
      } else if (/\s/.test(char)) {
        if (currentToken!== '') {
          tokens.push(currentToken);
          currentToken = '';
        }
      } else {
        if (currentToken!== '') {
          tokens.push(currentToken);
          currentToken = '';
        }
        tokens.push(char);
      }
    }
    if (currentToken!== '') {
      tokens.push(currentToken);
    }
    return tokens;
  }
}
@Entry
@Component
struct Index{
  @State cacu:string=' '
  @State Show:string=''
  @State result:string='0'
  build() {
    Column({space:10}){
      Blank()
      Column() {
        Text(this.result).fontColor(Color.Black).fontSize(50)
          .padding({ top: '0.00vp', right: '40.00vp', bottom: '0.00vp', left: '0.00vp' })
      }.width('100%').alignItems(HorizontalAlign.End)
      Column() {
        Text(this.Show).fontColor(Color.Black).fontSize(25)
          .padding({ top: '0.00vp', right: '40.00vp', bottom: '0.00vp', left: '0.00vp' })
      }.width('100%').alignItems(HorizontalAlign.End).height(40)
      Row({space:10}) {
        Button1({num:'AC',textColor:0xFF9F0B,textSize:30}).onClick(()=>{
          this.cacu=' '
          this.result='0'
          this.Show=''
        })
        Button1({num:'CE',textColor:0xFF9F0B,textSize:30}).onClick(()=>{
          this.cacu=this.cacu.slice(0,-1)
          this.Show=this.Show.slice(0,-1)
        })
        Button1({num:'%',textColor:0xFF9F0B,textSize:30}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!=' '&&this.cacu[this.cacu.length-1]!='+'&&this.cacu[this.cacu.length-1]!='-'&&this.cacu[this.cacu.length-1]!='.'&&this.cacu[this.cacu.length-1]!='%'&&this.cacu[this.cacu.length-1]!='×'&&this.cacu[this.cacu.length-1]!='÷'&&this.cacu[this.cacu.length-1]!='(')
          {this.cacu=this.cacu+'%'
          this.Show=this.Show+'%'}
        })
        Button1({num:'÷',textColor:0xFF9F0B}).onClick(()=> {
          if (this.cacu[this.cacu.length-1] != ' ' && this.cacu[this.cacu.length-1] != '+' &&
            this.cacu[this.cacu.length-1] != '-' && this.cacu[this.cacu.length-1] != '.' &&
            this.cacu[this.cacu.length-1] != '%' && this.cacu[this.cacu.length-1] != '×' &&
            this.cacu[this.cacu.length-1] != '÷')
          {
            this.cacu = this.cacu +'÷'
          this.Show = this.Show + '÷'
        }
        })
      }
      Row({space:10}) {
        Button1({num:'('}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!='0'&&this.cacu[this.cacu.length-1]!='1'&&this.cacu[this.cacu.length-1]!='2'&&this.cacu[this.cacu.length-1]!='3'&&this.cacu[this.cacu.length-1]!='4'&&this.cacu[this.cacu.length-1]!='5'&&this.cacu[this.cacu.length-1]!='6'&&this.cacu[this.cacu.length-1]!='7'&&this.cacu[this.cacu.length-1]!='9'&&this.cacu[this.cacu.length-1]!='8'&&this.cacu[this.cacu.length-1]!=')'&&this.cacu[this.cacu.length-1]!='.') {
            this.cacu = this.cacu + '(';
            this.Show = this.Show + '(';
          }else if((this.cacu[this.cacu.length-1]=='0'||this.cacu[this.cacu.length-1]||'1'&&this.cacu[this.cacu.length-1]=='2'||this.cacu[this.cacu.length-1]=='3'||this.cacu[this.cacu.length-1]=='4'||this.cacu[this.cacu.length-1]=='5'||this.cacu[this.cacu.length-1]=='6'||this.cacu[this.cacu.length-1]=='7'||this.cacu[this.cacu.length-1]=='9'||this.cacu[this.cacu.length-1]=='8'||this.cacu[this.cacu.length-1]==')')&&this.cacu[this.cacu.length-1]!='.') {
            this.cacu = this.cacu + '×' + '('
            this.Show = this.Show + '('
          }
        })
        Button1({num:')'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!=' '&&this.cacu[this.cacu.length-1]!='.'&&this.cacu[this.cacu.length-1]!='-'&&this.cacu[this.cacu.length-1]!='.'&&this.cacu[this.cacu.length-1]!='%'&&this.cacu[this.cacu.length-1]!='×'&&this.cacu[this.cacu.length-1]!='÷') {
            {this.cacu = this.cacu + ')'
            this.Show=this.Show+')'
            }
          }
        })
        Button1({num:'π'}).onClick(()=>{
          this.cacu=this.cacu+'×'+3.1415926
          this.Show=this.Show+'π'
        })
        Button1({num:'M',textColor:0xFF9F0B}).onClick(()=>{
          //跳转到下一页router。push{url:}
        })
      }
      Row({space:10}) {
        Button1({num:'7'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+7
            this.Show=this.Show+7
          }else
          {this.cacu=this.cacu+7
          this.Show=this.Show+7}
        })
        Button1({num:'8'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+8
            this.Show=this.Show+8
          }else
          {this.cacu=this.cacu+8
            this.Show=this.Show+8}
        })
        Button1({num:'9'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+9
            this.Show=this.Show+9
          }else
          {this.cacu=this.cacu+9
            this.Show=this.Show+9}
        })
        Button1({num:'+',textColor:0xFF9F0B}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!=' '&&this.cacu[this.cacu.length-1]!='('&&this.cacu[this.cacu.length-1]!='-'&&this.cacu[this.cacu.length-1]!='.'&&this.cacu[this.cacu.length-1]!='%'&&this.cacu[this.cacu.length-1]!='+'&&this.cacu[this.cacu.length-1]!='×'&&this.cacu[this.cacu.length-1]!='÷')
          { this.cacu=this.cacu+'+'
          this.Show=this.Show+'+'}
        })
      }
      Row({space:10}) {
        Button1({num:'4'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+4
            this.Show=this.Show+4
          }else
          {this.cacu=this.cacu+4
            this.Show=this.Show+4}
        })
        Button1({num:'5'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+5
            this.Show=this.Show+5
          }else
          {this.cacu=this.cacu+5
            this.Show=this.Show+5}
        })
        Button1({num:'6'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+6
            this.Show=this.Show+6
          }else
          {this.cacu=this.cacu+6
            this.Show=this.Show+6}
        })
        Button1({num:'-',textColor:0xFF9F0B}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!='0'&&this.cacu[this.cacu.length-1]!='1'&&this.cacu[this.cacu.length-1]!='2'&&this.cacu[this.cacu.length-1]!='3'&&this.cacu[this.cacu.length-1]!='4'&&this.cacu[this.cacu.length-1]!='5'&&this.cacu[this.cacu.length-1]!='6'&&this.cacu[this.cacu.length-1]!='7'&&this.cacu[this.cacu.length-1]!='9'&&this.cacu[this.cacu.length-1]!='8'&&this.cacu[this.cacu.length-1]!='.'&&this.cacu[this.cacu.length-1]!='%'&&this.cacu[this.cacu.length-1]!=''&&(this.cacu[this.cacu.length-1]=='+'||this.cacu[this.cacu.length-1]=='×'||this.cacu[this.cacu.length-1]=='÷'))
      {this.cacu=this.cacu+'('+'-'
       this.Show=this.Show+'('+'-'}
          // else if(this.cacu[this.cacu.length-1]==')'){
          //   this.cacu=this.cacu+'-'+'('
          //   this.Show=this.Show+'-'+'('
          // }
          if (this.cacu[this.cacu.length-1]=='-')
          {
            this.cacu=this.cacu
            this.Show=this.Show
          }
        else{
          this.cacu=this.cacu+'-'
          this.Show=this.Show+'-'
         }
      })
      }
      Row({space:10}) {
        Button1({num:'1'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+1
            this.Show=this.Show+1
          }else
          {this.cacu=this.cacu+1
            this.Show=this.Show+1}
        })
        Button1({num:'2'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+2
            this.Show=this.Show+2
          }else
          {this.cacu=this.cacu+2
            this.Show=this.Show+2}
        })
        Button1({num:'3'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]==')'){
            this.cacu=this.cacu+'×'+3
            this.Show=this.Show+3
          }else
          {this.cacu=this.cacu+3
            this.Show=this.Show+3}
        })
        Button1({num:'×',textColor:0xFF9F0B}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!=' '&& this.cacu[this.cacu.length-1]!='('&& this.cacu[this.cacu.length-1]!='-'&&this.cacu[this.cacu.length-1]!='.'&&this.cacu[this.cacu.length-1]!='%'&&this.cacu[this.cacu.length-1]!='×'&&this.cacu[this.cacu.length-1]!='÷'&&this.cacu[this.cacu.length-1]!='(')
          { this.cacu=this.cacu+'×'
          this.Show=this.Show+'×'}
        })
      }
      Row({space:10}){
        Button1({num:'0'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]!=')'&&this.cacu[this.cacu.length-1]!=' ')
          {this.cacu=this.cacu+0
            this.Show=this.Show+0}
        })
        Button1({num:'.'}).onClick(()=>{
          if(this.cacu[this.cacu.length-1]=='.'){
            this.cacu=this.cacu
            this.Show=this.Show
          }
         else if(this.cacu[this.cacu.length-1]!='0'&&this.cacu[this.cacu.length-1]!='1'&&this.cacu[this.cacu.length-1]!='2'&&this.cacu[this.cacu.length-1]!='3'&&this.cacu[this.cacu.length-1]!='4'&&this.cacu[this.cacu.length-1]!='5'&&this.cacu[this.cacu.length-1]!='6'&&this.cacu[this.cacu.length-1]!='7'&&this.cacu[this.cacu.length-1]!='9'&&this.cacu[this.cacu.length-1]!='8'&&(this.cacu[this.cacu.length-1]=='+'|| this.cacu[this.cacu.length-1]=='('||this.cacu[this.cacu.length-1]==')'&&this.cacu[this.cacu.length-1]=='-'||this.cacu[this.cacu.length-1]==' '||this.cacu[this.cacu.length-1]=='%'||this.cacu[this.cacu.length-1]=='×'||this.cacu[this.cacu.length-1]=='÷'||this.cacu[this.cacu.length-1]==''))
          {this.cacu=this.cacu+0+'.'
            this.Show=this.Show+0+'.'}
          else{
            this.cacu=this.cacu+'.'
            this.Show=this.Show+'.'
          }
        })
        Button2({num:'=',buttonColor:0xFF9F0B,textColor:Color.White}).onClick(()=>{
          if (!this.isBracketBalanced(this.cacu)) {
            this.result = '输入错误';
          } else {
            console.log(this.cacu);
            const calculator = new DoubleStackCalculatorWithParentheses();
            this.result = calculator.calculate(this.cacu).toString();
          }
        })
      }
      .margin({ top: '0.00vp', right: '0.00vp', bottom: '40.00vp', left: '0.00vp' })
    }.width('100%')
    .height('100%')
    .backgroundColor('#fff5f5f5')
  }
isBracketBalanced(cacu: string): boolean {
  let leftBracketCount = 0;
  let rightBracketCount = 0;

  for (let char of cacu) {
    if (char === '(') {
      leftBracketCount++;
    } else if (char === ')') {
      rightBracketCount++;
    }
  }
  return leftBracketCount === rightBracketCount;
}
}
