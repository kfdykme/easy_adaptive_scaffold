<?code-excerpt path-base="example/lib"?>

# EasyAdaptiveScaffoldasyAdaptive

> Fork from https://github.com/flutter/packages

fix some bug of https://github.com/flutter/packages ,flutter_adaptive_scaffold widget. 


`AdaptiveScaffold` reacts to input from users, devices and screen elements and
renders your Flutter application according to the
[Material 3](https://m3.material.io/foundations/adaptive-design/overview)
guidelines.
# Prview 
![Image](https://raw.githubusercontent.com/kfdykme/easy_adaptive_scaffold/assets/preview_1.gif) 

# Example Usage
``` dart
  
  List<EasyAdaptiveLayoutNavItemConfig> initConfigs() {
    return List.filled(10,1).map((i){
      String title = (Random().nextInt(10000) + 1000).toRadixString(16);
      return EasyAdaptiveLayoutNavItemConfig(title: title, icon:  const Icon(Icons.abc), builder: (context) {
        return Text(title);
      },);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return EasyAdaptiveLayout(
      navConfigs: initConfigs(),
    );
  }
```


# BugFix
- Animation Bug while use both AdaptiveScaffold and AdaptiveLayout
# Features 
- Make easy to use [DONE]
- hook router to push or open second layout [TODO]



