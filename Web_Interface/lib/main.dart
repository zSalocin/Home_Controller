import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'interface_page_blocks.dart';
import 'firebase_options.dart';
import 'components.dart';
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
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              return Scaffold(
                body: Center(
                  child: wdialogBox(
                    context,
                    'Error',
                    snapshot.error.toString(),
                  ),
                ),
              );
            } else {
              return const HomePage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                          ),
                          const SizedBox(
                              height: 20), // Add some spacing between fields
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(
                              height: 20), // Add some spacing between fields
                          ElevatedButton(
                            onPressed: () {
                              checkConnectivity();
                              fetchBlocks();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const INTERFACE(),
                              //   ),
                              // );
                            },
                            child: const Text("Entry"),
                          )
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