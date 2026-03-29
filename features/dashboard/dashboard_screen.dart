import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../common/custom_body/custom_body.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../localization/provider/language_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../document_section/dot/view/dot_select_document.dart';
import 'package:grozziie/utils/local_storage/local_data.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/features/auth/view/login_screen.dart';
import '../document_section/thermal/view/thermal_select_document.dart';
import '../teamplated/local_templated/view/local_template_tab_view.dart';
import 'package:grozziie/utils/constants/label_global_variable.dart';
import '../teamplated/server_teamplated/view/server_teamplated_tab_view.dart';
import 'package:grozziie/features/new_label/printer_type/dot/view/dot_paper_size.dart';
import 'package:grozziie/features/new_label/printer_type/thermal/view/thermal_paper_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/env.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _appVersion = '';
  String _buildVersion = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildVersion = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _checkAndCallOpenApi();
  }

  Future<void> _checkAndCallOpenApi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCallDateStr = prefs.getString('last_open_api_call_date');
      final today = DateTime.now();

      bool shouldCall = false;
      if (lastCallDateStr == null) {
        shouldCall = true;
      } else {
        final lastCallDate = DateTime.parse(lastCallDateStr);

        // Normalize dates (remove time component)
        final todayDate = DateTime(today.year, today.month, today.day);
        final lastDate = DateTime(lastCallDate.year, lastCallDate.month, lastCallDate.day);

        // Only call API if today is genuinely after the last call date
        // Prevents API call if user manipulates system date backwards
        shouldCall = todayDate.isAfter(lastDate);
      }

      if (shouldCall) {
        try {
          final url = Uri.parse('${Env.pBaseUrl}/api/app/open');
          final response = await http.post(url, headers: {'accept': '*/*'}, body: '');

          if (response.statusCode == 200) {
            // Store date in YYYY-MM-DD format
            final dateStr =
                '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
            await prefs.setString('last_open_api_call_date', dateStr);
            debugPrint("Open API Call Status: ${response.statusCode}, Response: ${response.body}");
          }
        } catch (e) {
          debugPrint("Open API Call Failed: $e");
        }
      }
    } catch (e) {
      debugPrint("Error in Open API check: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return CustomBody(
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return NavigationView(
            appBar: NavigationAppBar(
              height: 24,
              automaticallyImplyLeading: false,
              /*actions: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      !isUserLoggedIn ? FluentIcons.contact : (isAdmin ? FluentIcons.shield : FluentIcons.contact),
                      size: 24,
                      color: !isUserLoggedIn ? Colors.grey[100] : (isAdmin ? Colors.blue : Colors.green),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          !isUserLoggedIn ? dTexts.guest : (isAdmin ? dTexts.admin : dTexts.user),
                          style: context.bodyStrong.copyWith(fontSize: 14),
                        ),
                        Text(
                          !isUserLoggedIn ? dTexts.offline : (isAdmin ? dTexts.administrator : dTexts.standardUser),
                          style: context.caption.copyWith(fontSize: 11, color: Colors.grey[100]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),*/
            ),
            pane: NavigationPane(
              selected: _selectedIndex,
              onChanged: _onItemTapped,
              displayMode: PaneDisplayMode.auto,
              size: NavigationPaneSize(openWidth: 250.w),
              items: [
                /// New Option section
                PaneItem(
                  icon: const Icon(FluentIcons.a_a_d_logo),
                  title: Text(dTexts.newLabel, style: context.subtitle),
                  body: const ThermalPaperSizeScreen(),
                ),

                PaneItem(
                  icon: const Icon(FluentIcons.a_a_d_logo),
                  title: Text(dTexts.dotLabel, style: context.subtitle),
                  body: const DotPaperSizeScreen(),
                ),

                PaneItem(
                  icon: const Icon(FluentIcons.recent),
                  title: Text(dTexts.localTemplate, style: context.subtitle),
                  body: const LocalTemplateTabView(),
                ),

                PaneItem(
                  icon: const Icon(FluentIcons.recent),
                  title: Text(dTexts.serverTemplate, style: context.subtitle),
                  body: const ServerTemplateTabView(),
                ),

                /// thermal document Print section
                PaneItem(
                  icon: const Icon(FluentIcons.pdf),
                  title: Text(dTexts.documentPrint, style: context.subtitle),
                  body: const ThermalSelectDocument(),
                ),

                /// dot document Print section
                PaneItem(
                  icon: const Icon(FluentIcons.pdf),
                  title: Text(dTexts.dotDocument, style: context.subtitle),
                  body: const DotSelectDocument(),
                ),

                /*/// Language section
                PaneItemSeparator(),
                PaneItem(
                  icon: const Icon(FluentIcons.locale_language),
                  title: Text(dTexts.languageSettings, style: context.subtitle),
                  body: const SizedBox.shrink(),
                  onTap: () => languageProvider.showLanguageDialog(context),
                ),*/
              ],
              footerItems: [
                PaneItemSeparator(),
                PaneItemAction(
                  icon: Icon(isUserLoggedIn ? FluentIcons.sign_out : FluentIcons.contact),
                  title: Text(isUserLoggedIn ? dTexts.logOut : dTexts.logIn, style: context.subtitle),
                  onTap: () {
                    if (isUserLoggedIn) {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return ContentDialog(
                            title: Text(dTexts.confirmLogout, style: context.titleLarge),
                            content: Text(dTexts.areYouSureLogout),
                            actions: [
                              Button(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: Text(dTexts.cancel),
                              ),
                              FilledButton(
                                child: Text(dTexts.logOut),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  isUserLoggedIn = false;
                                  isAdmin = false;
                                  LocalData.destroyer();
                                  setState(() {});
                                  Navigator.pushReplacement(
                                    context,
                                    FluentPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.info),
                  title: Text("${dTexts.version}: $_appVersion($_buildVersion)", style: context.subtitle),
                  body: const SizedBox.shrink(),
                  enabled: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
