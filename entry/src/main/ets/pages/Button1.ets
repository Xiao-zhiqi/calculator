@Preview
@Component
export struct Button1{
  num:string ='1'
  buttonColor:number=Color.White
  textColor:number=Color.Grey
  textSize:number=35
  build() {

    Column(){
      Text(this.num)
        .fontColor(this.textColor)
        .fontSize(this.textSize)
        .fontWeight(FontWeight.Normal)
    }
    .width(75)
    .height(75)
    .backgroundColor(this.buttonColor)
    .justifyContent(FlexAlign.Center)
    .borderRadius(37.5)
  }
}