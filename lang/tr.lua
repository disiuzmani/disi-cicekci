local Translations = {
    error = {
        negative = 'Negatif bir tutarda mı satmaya çalışıyorsunuz?',
        no_items = 'Eşyaya Sahip Değilsiniz',
        no_license = '%{value} lisansınız yok'
    },
    success = {
        sold = '%{value} x %{value2} yi $%{value3} karşılığında sattınız',
    },
    info = {
        title = 'Tüccar',
        sell = 'Eşya Sat',
        sell_to = 'Tüccara Eşya Sat',
        sell_items = 'Satış Fiyatı $%{value}',
        buy = 'Eşya Al',
        buy_from = 'Tüccardan Eşya Al',
        back = '⬅ Geri Dön',
        max = 'Maksimum Sayı %{value}',
        close = 'Kapat'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})