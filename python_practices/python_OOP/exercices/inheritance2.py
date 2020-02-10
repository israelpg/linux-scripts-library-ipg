class Product:
    def __init__(self, name, pid, price):
        self.productName = name
        self.productId = pid
        self.productPrice = price

    def printProductBasics(self):
        print('Product Basic Info: ', self.productName, self.productId, self.productPrice)

class TechnologyItem(Product):
    def __init__(self, name, pid, price, category, brand):
        super().__init__(name, pid, price)
        self.itemCategory = category
        self.itemBrand = brand

    def detailsTechItem(self):
        print("About product: ", self.productName, self.productId, self.productPrice, "with details: ", self.itemCategory, self.itemBrand)

objectTech = TechnologyItem("Asus NX650U", "lap-asus-2019-nx650-u", 850, "Laptop", "Asus")
objectTech.printProductBasics()
objectTech.detailsTechItem()
