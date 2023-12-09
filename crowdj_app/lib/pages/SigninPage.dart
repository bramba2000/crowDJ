import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends StatefulWidget {

  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    bool _userType = false;
    TextEditingController _nameController = TextEditingController();
    TextEditingController _surnamenameController = TextEditingController();
    bool _res=false;

    bool _sigin(){

      //asking to the db to add a new user
      return true;

    }

    void toggleButtonState(){

      setState(() {
        _userType = !_userType;
      });

    }
    
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Signin Page")
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'password'),
              ), 
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'name'),
              ),
              TextField(
                controller: _surnamenameController,
                decoration: const InputDecoration(labelText: 'surname'),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: toggleButtonState,
                    child: const Text('change'),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    _userType ? 'DJ' : 'USER',
                    style: const TextStyle(fontSize: 14),
                  ), 
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:(){
                  _res=_sigin();
                  context.go('/homePage');
                  if(_res){
                    //context.goNamed('/homePage');
                  }
                  else{
                    context.go('/signinPage');
                  }
                },
                child: const Text('join crowDJ'),
            ),       
            ],
          )
        )

      );


    }


}