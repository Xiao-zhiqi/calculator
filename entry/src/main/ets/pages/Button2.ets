@Component
export struct Button2{
  num:string ='0'
  buttonColor:number=Color.White
  textColor:number=Color.Grey
  textSize:number=40

  build() {
  Column(){
    Text(`${this.num}`)
      .fontColor(this.textColor)
      .fontSize(this.textSize)
      .fontWeight(FontWeight.Medium )
  }
  .width(160)
  .height(75)
  .backgroundColor(this.buttonColor)
  .justifyContent(FlexAlign.Center)
  .borderRadius(37.5)

  }
}