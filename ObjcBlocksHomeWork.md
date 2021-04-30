# Различие objective-c блоков от Swift closure

Синтаксис блоков в obj-c:
***ReturnType(^blockName)(Parameters)***
 - ***ReturnType:*** Любые типы, которые поддерживает  Obj-C, либо void, если функция возвращает ничего
 -  ***\^blockName*** имена блоков всегда начинаются с символа ***^***. Имя блока может быть любой строкой, также как мы именуем переменные и функции. Стоит отметить, что символ ***^*** и имя блока помещается внутри скобок.
 -   ***Parameters:*** Список папраметров, которые мы хотим передать в блок. Стоит отметить, что когда мы не передаем никаких параметров в блок, то нам необходимо использовать ключевое слово void. Аргументы также должны быть заключены в скобки.
``` objc
int (^firstBlock)(NSString *param1, int param2);
void (^showName)(NSString *myName);
NSDate *(^whatDayIsIt)(void);
void (^allVoid)(void);
NSString *(^composeName)(NSString *firstName, NSString *lastName)
```

Особенностью объявления блока является то, что имена параметров можно не указывать, а просто сохранять типы параметров. Фактически, добавление имен параметров в объявление только помогает разработчикам их запоминать, но ничего не предлагает компилятору. Итак, на этот раз все приведенные выше объявления можно было бы переписать без имен параметров: 
``` objc
int (^firstBlock)(NSString *, int);
void (^showName)(NSString *);
NSDate *(^whatDayIsIt)(void);
void (^allVoid)(void);
NSString *(^composeName)(NSString *, NSString *);
```
Использование или отсутствие имен параметров полностью зависит от вас. Нет ничего плохого в их использовании и в том, чтобы их не пропускать.

 Может и не существовать имен у блоков.

 ``` objc
^(Parameters){
... block body ...
return ReturnValue (or nothing if the block return type is void)
};

 ^(int a, int b){
 int result = a * b;
 return result;
 };
```

Пример использования с переменной объявленной вне блока.
``` objc
 int factor = 5;
 int (^newResult)(void) = ^(void){
 return factor * 10;
 };
 NSLog(@"%d", newResult());
 // Output: 50
 ``` 
 
 В следующем примере при компиляции мы получим ошибку на строке someValue += 5
 ``` objc
 -(void)testBlockStorageType{
 int someValue = 10;
 int (^myOperation)(void) = ^(void){
 someValue += 5;
 return someValue + 10;
 };

 NSLog(@"%d", myOperation());
}
```
Для разрешения этой ситуации существует ***storage type modifier***, который назывется ***__block***  и используется при декларации переменной. Это позволяет сделать переменную  mutable для блока

 ``` objc
__block int someValue = 10;
```

Синтаксис для использования блока в качестве completion
 ``` objc
-(returnType)methodNameWithParams:(parameterType)parameterName ...<more params>... andCompletionHandler:(void(^)(<any block params>))completionHandler{

 ...

 ...

 // When the callback should happen:

 completionHandler(<any required parameters>);

}



[self methodNameWithParams:parameter1 ...<more params>... andCompletionHandler:^(<any block params>){

 // The completion handler code is added here after the method has finished execution and has made a callback.

}];
 ``` 
 ## Расположение блоков
 ### NSStackBlock
 Если же блок захватывает внешние переменные, то блок \_\_NSStackBlock\_\_ (на стеке)
  ``` objc
 int foo = 3;
 Class class = [^{ 
 int foo1 = foo + 1; 
 } class];
 NSLog(@"%@", NSStringFromClass(class));
  ```
  ### NSMallockBlock
  Однако если же послать блоку 'copy', то блок будет скопирован в кучу (\_\_NSMallocBlock\_\_).
  ``` objc
  int foo = 3;
  Class class = [[^{ 
  int foo1 = foo + 1;
  } copy] class]; 
  NSLog(@"%@", NSStringFromClass(class));
  ```
  ### NSGlobalBlock
 сли блок не захватывает внешние переменные, то мы получаем \_\_NSGlobalBlock\_\_
 ``` objc
Class class = [^{ 
} class]; 
NSLog(@"%@", NSStringFromClass(class));
  ```
## Summary: 
- В objc при использовании переменных, объявленных вне блока, используется их копия т. е. любые модификации внутри блока не будут влиять на значение переменной вне блока, чтобы изменения сохранялись и вне блока нужно при декларации переменной приписывать ***__block***. 
- В это же время в Swift наооборот, значение меняется как внутри блока так и снаружи, но мы можем использовать capture list. Для value типов capture list делает их immutable. Для refrence типов  capture list делает  immutable ссылку на объект, но поля объекта можно изменять.
- Также в swift доступно использование unowned и weak. При weak. не создается сильная ссылка на объект, что оберегает от retain циклов, утечек памяти. Unowned это почти тоже самое, что и weak, но отличие в том, что weak делает объект optional. При использовании unowned мы точно должны знать, что значени не будет nil