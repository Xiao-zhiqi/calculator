# calculator
一、整体架构设计
鸿蒙计算器采用分层设计，各层职责清晰：

UI 层：负责界面渲染与用户交互
逻辑层：处理输入验证与状态管理
计算层：实现表达式解析与运算逻辑
三层通过状态变量与方法调用衔接，形成完整的功能闭环。



二、UI 层实现细节
基于鸿蒙声明式 UI 框架，采用 "显示区 + 按钮区" 的经典布局：

typescript

@Entry
@Component
struct Index{
  // 状态管理：存储计算表达式、显示内容和结果
  @State cacu:string=' '  
  @State Show:string=''   
  @State result:string='0'
  
  build() {
    Column({space:10}){
      // 1. 显示区域
      Column() {
        Text(this.result).fontSize(50)  // 结果显示（大字体）
      }.width('100%').alignItems(HorizontalAlign.End)
      
      Column() {
        Text(this.Show).fontSize(25)   // 表达式显示（小字体）
      }.width('100%').alignItems(HorizontalAlign.End)
      
      // 2. 按钮区域（网格布局）
      Row({space:10}) {  // 功能按钮行
        Button1({num:'AC'}).onClick(()=>{/* 清空逻辑 */})
        Button1({num:'CE'}).onClick(()=>{/* 删除逻辑 */})
        Button1({num:'%'}).onClick(()=>{/* 取余输入 */})
        Button1({num:'÷'}).onClick(()=>{/* 除法输入 */})
      }
      
      // 数字与运算符按钮行（共4行）
      Row({space:10}) {
        Button1({num:'7'}).onClick(()=>{/* 数字输入 */})
        // 其他按钮...
        Button1({num:'+'}).onClick(()=>{/* 加法输入 */})
      }
      
      // 等号按钮（触发计算）
      Button2({num:'='}).onClick(()=>{
        if(this.isBracketBalanced(this.cacu)){
          const calculator = new DoubleStackCalculator();
          this.result = calculator.calculate(this.cacu).toString();
        }
      })
    }.width('100%').height('100%')
  }
}
AI写代码

三、逻辑层核心功能
输入验证：

防止连续输入运算符（如 "1++2"）
控制小数点唯一性（如 "1..2" 不合法）
处理括号与数字的自动补乘（如 "(2) 3"→"(2)×3"）
括号平衡校验：

typescript

isBracketBalanced(cacu: string): boolean {
  let left=0, right=0;
  for (let char of cacu) {
    if (char === '(') left++;
    else if (char === ')') right++;
  }
  return left === right;
}
AI写代码
四、计算层核心实现
运算符接口设计：
typescript

interface Operator {
  symbol: string;        // 运算符符号
  precedence: number;    // 优先级（1：加减，2：乘除取余）
  operation: (a: number, b: number) => number;  // 运算逻辑
}
 
// 运算符实例数组
const operators: Operator[] = [
  { symbol: '+', precedence: 1, operation: (a, b) => a + b },
  { symbol: '-', precedence: 1, operation: (a, b) => a - b },
  // 其他运算符...
];
AI写代码

双栈算法核心：
typescript

class DoubleStackCalculator {
  private operandStack: number[] = [];  // 存储数字
  private operatorStack: string[] = []; // 存储运算符
 
  calculate(expression: string): number {
    const tokens = this.tokenizeExpression(expression); // 表达式分词
    
    for (const token of tokens) {
      if (是数字) {
        入操作数栈;
      } else if (是左括号) {
        入运算符栈;
      } else if (是右括号) {
        计算到对应左括号;
      } else { // 是运算符
        按优先级处理运算符栈;
        当前运算符入栈;
      }
    }
    
    处理剩余运算符，返回最终结果;
  }
}
AI写代码

五、核心流程
用户点击按钮 → 更新cacu和Show状态
输入验证 → 确保表达式格式合法
点击等号 → 调用双栈计算器计算
计算结果 → 更新result状态，UI 自动刷新
这种结构既保证了界面交互的流畅性，又通过接口化设计提升了计算逻辑的可维护性和扩展性。
              
原文链接：https://blog.csdn.net/2301_79847249/article/details/152210847
