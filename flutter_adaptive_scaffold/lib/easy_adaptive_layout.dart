import 'package:flutter/material.dart';
import 'flutter_adaptive_scaffold.dart';

class EasyAdaptiveLayoutNavItemConfig {
  String title;
  Icon? icon;
  WidgetBuilder? builder;
  EasyAdaptiveLayoutNavItemConfig({this.title = '', this.builder, this.icon}) {
    builder ??= (context) {
      return Text("body $title");
    };
  }
}

class EasyAdaptiveLayout extends StatefulWidget {
  final List<EasyAdaptiveLayoutNavItemConfig> navConfigs;
  final ValueNotifier<Widget?>? secondaryNotifier;
  const EasyAdaptiveLayout({super.key, this.navConfigs = const [], this.secondaryNotifier});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EasyAdaptiveLayoutState();
  }
}

class EasyAdaptiveLayoutRouteData {
  ValueNotifier<Widget?> secondaryBodyNotifier = ValueNotifier<Widget?>(null);
}

class EasyAdaptiveLayoutRouteHolder extends InheritedWidget {
  final EasyAdaptiveLayoutRouteData data;
  EasyAdaptiveLayoutRouteHolder({super.key, required super.child, required this.data});

  bool enableInterupteRoute = true;

  ValueNotifier<Widget?> get secondaryBodyNotifier => data.secondaryBodyNotifier;

  static EasyAdaptiveLayoutRouteHolder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EasyAdaptiveLayoutRouteHolder>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class EasyAdaptiveLayoutState extends State<EasyAdaptiveLayout> {
  int selectedIndex = 0;

  List<NavigationRailDestination> buildMediumNav() {
    List<NavigationRailDestination> mediumsList = [];
    for(var index = 0; index < widget.navConfigs.length; index++) {
      final i = widget.navConfigs[index];
      final item =  NavigationRailDestination(
        label: Text(
          i.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        icon: (index == selectedIndex && i.icon != null
                ? Icon(
                    i.icon!.icon,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : i.icon ?? Text(i.title)) ??
            Text(i.title),
      );
      mediumsList.add(item);
    }

    return mediumsList;
  }

  List<NavigationDestination> buildBottom() {
    return widget.navConfigs.map((i) {
      return NavigationDestination(label: i.title, icon: i.icon ?? Text(i.title));
    }).toList();
  }

  void onChagneLNav(int index) {
    selectedIndex = index;

    final secondaryNotifier =
        EasyAdaptiveLayoutRouteHolder.of(context)?.secondaryBodyNotifier ?? widget.secondaryNotifier;
    secondaryNotifier?.value = null;
    refireshLayout();
  }

  void refireshLayout() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    final secondaryNotifier =
        EasyAdaptiveLayoutRouteHolder.of(context)?.secondaryBodyNotifier ?? widget.secondaryNotifier;
    secondaryNotifier?.removeListener(() {
      refireshLayout();
    });
  }

  @override
  Widget build(BuildContext context) {
    final secondaryNotifier =
        EasyAdaptiveLayoutRouteHolder.of(context)?.secondaryBodyNotifier ?? widget.secondaryNotifier;
    secondaryNotifier?.removeListener(() {
      refireshLayout();
    });
    secondaryNotifier?.addListener(() {
      refireshLayout();
    });
    return MaterialApp(
      home: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            // Usage of AdaptiveLayout suite begins here. AdaptiveLayout takes
            // LayoutSlots for its variety of screen slots.
            body: AdaptiveLayout(
              // Each SlotLayout has a config which maps Breakpoints to
              // SlotLayoutConfigs.
              primaryNavigation: SlotLayout(
                config: <Breakpoint, SlotLayoutConfig?>{
                  // The breakpoint used here is from the Breakpoints class but custom
                  // Breakpoints can be defined by extending the Breakpoint class
                  Breakpoints.medium: SlotLayout.from(
                    // Every SlotLayoutConfig takes a key and a builder. The builder
                    // is to save memory that would be spent on initialization.
                    key: const Key('primaryNavigation'),
                    duration: const Duration(milliseconds: 250),
                    inAnimation: AdaptiveScaffold.fadeIn,
                    outAnimation: AdaptiveScaffold.fadeOut,
                    builder: (_) {
                      EasyAdaptiveLayoutRouteHolder.of(context)?.enableInterupteRoute = true;
                      return AdaptiveScaffold.standardNavigationRail(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        selectedIndex: selectedIndex,
                        onDestinationSelected: onChagneLNav,
                        destinations: buildMediumNav(),
                      );
                    },
                  ),
                  Breakpoints.large: SlotLayout.from(
                      key: const Key('Large primaryNavigation'),
                      duration: const Duration(milliseconds: 250),
                      // The AdaptiveScaffold builder here greatly simplifies
                      // navigational elements.
                      inAnimation: AdaptiveScaffold.fadeIn,
                      outAnimation: AdaptiveScaffold.fadeOut,
                      builder: (_) {
                        // EasyAdaptiveLayoutRouteHolder.of(context)?.enableInterupteRoute = true;
                        return AdaptiveScaffold.standardNavigationRail(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          extended: true,
                          selectedIndex: selectedIndex,
                          onDestinationSelected: onChagneLNav,
                          destinations: buildMediumNav(),
                        );
                      }),
                },
              ),
              body: SlotLayout(
                config: <Breakpoint, SlotLayoutConfig?>{
                  Breakpoints.standard: SlotLayout.from(
                    key: const Key('body'),
                    // The conditional here is for navigation screens. The first
                    // screen shows the main screen and every other screen shows
                    //  ExamplePage.
                    duration: const Duration(milliseconds: 50),
                    outAnimation: AdaptiveScaffold.fadeOut,
                    builder: (_) =>
                        widget.navConfigs[selectedIndex].builder?.call(context) ?? Text("$selectedIndex $_"),
                  ),
                },
              ),
              secondaryBody: secondaryNotifier?.value != null
                  ? SlotLayout(
                      config: <Breakpoint, SlotLayoutConfig?>{
                        Breakpoints.standard: SlotLayout.from(
                          key: Key('secondaryBody ${secondaryNotifier!.value.hashCode}'),
                          // The conditional here is for navigation screens. The first
                          // screen shows the main screen and every other screen shows
                          //  ExamplePage.
                          // outAnimation: AdaptiveScaffold.fadeOut,

                          duration: const Duration(milliseconds: 50),
                          builder: (_) {
                            return ValueListenableBuilder(
                              valueListenable: secondaryNotifier!,
                              builder: (context, value, child) {
                                return value!;
                              },
                            );
                          },
                        ),
                        Breakpoints.smallDesktop: null
                      },
                    )
                  : null,
              bottomNavigation: SlotLayout(
                config: <Breakpoint, SlotLayoutConfig?>{
                  Breakpoints.small: SlotLayout.from(
                    key: const Key('bottomNavigation'),
                    // You can define inAnimations or outAnimations to override the
                    // default offset transition.

                    duration: const Duration(milliseconds: 250),
                    outAnimation: AdaptiveScaffold.topToBottom,
                    builder: (_) {
                      // EasyAdaptiveLayoutRouteHolder.of(context)?.enableInterupteRoute = false;
                      return AdaptiveScaffold.standardBottomNavigationBar(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onDestinationSelected: onChagneLNav,
                        currentIndex: selectedIndex,
                        destinations: buildBottom(),
                      );
                    },
                  )
                },
              ),
            ),
          )),
    );
  }
}
