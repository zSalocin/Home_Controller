import 'package:flutter/material.dart';
import 'package:tcc_2023/components.dart';
import 'package:tcc_2023/interface_page_blocks.dart';
import 'backend_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String password = "";

  String username = "";

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/background_image.jpg', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor: 0.3,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Form(
                    key: formKey,
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'User Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a user name';
                              }
                              return null;
                            },
                            onSaved: (value) => username = value!,
                          ),
                          const SizedBox(
                              height: 20), // Add some spacing between fields
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            onSaved: (value) => password = value!,
                          ),
                          const SizedBox(
                              height: 20), // Add some spacing between fields
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    String? token =
                                        await getToken(username, password);
                                    if (token != null) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => INTERFACE(
                                            token: token,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      dialogBox(context, "error",
                                          "Falha na autenticação");
                                    }
                                  }
                                },
                                child: const Text("Entry"),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  userRegister(context);
                                },
                                child: const Text("sing-in"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//TODO organizar tile de blocos, elementos, sensores
//TODO concertar elementos havera um para ligar, e um para sinalizar se esta ligado, enable e stats ja esta na classe.

//TODO ordens
// Atualizar metodos do firebase OK
// Atualizar firebaseCALL + components (concertar os firebasecall e jogar isso pra components) OK (falta coisinhas no element)
// Adicionar o pin Attach para sensores classe e metodos ja feitos?
// Completar pagina de config
// Completar pagina de roomPage
// Atualizar programa do ESP

// --- Metas pos TCC

// Atualizar tudo pra conter usuarios e permissoes
// fazer BackEnd separado