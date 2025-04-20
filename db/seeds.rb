Company.create!(
  name: "帝国金融",
  description: "大阪府に本社を置く、貸金業を営む企業。主に中小企業向けの融資を行っている。",
  company_synonyms_attributes: [
    { name: "バンク・オブ・エンペラー" },
  ]
)

Company.create!(
  name: "雑巾自動車",
  description: "中古車販売を行う企業。特にスポーツカーに強みを持つ。",
  company_synonyms_attributes: [
    { name: "Zokin Motors" },
  ]
)

Company.create!(
  name: "ニシキヘビファイナンス",
  description: "支店を大量に出しているため勢いがありそうに見える貸金業者。",
  company_synonyms_attributes: [
    { name: "Python Finance" },
  ]
)
