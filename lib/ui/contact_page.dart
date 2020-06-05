import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {


  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editContact;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  bool _userEdited = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
              title: Text(_editContact.name ?? "Novo Contato"),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_editContact.name != null && _editContact.name.isNotEmpty) {
                  Navigator.pop(context, _editContact);
                } else {
                  FocusScope.of(context).requestFocus(_nameFocus);
                }
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.redAccent,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _editContact.img != null
                                ? FileImage(File(_editContact.img))
                                : AssetImage("images/person.png"),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      onTap: (){
                        _userEdited = true;
                        // ignore: deprecated_member_use
                        ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                          if(file == null) return;
                          setState(() {
                            _editContact.img = file.path;
                          });
                        })
                        ;
                      },
                    ),
                    TextField(
                      focusNode: _nameFocus,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Nome",
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        setState(() {
                          _editContact.name = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                      onChanged: (text) {
                        _editContact.email = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        hintText: _editContact.phone,
                      ),
                      onChanged: (text) {
                        _editContact.phone = text;
                      },
                      keyboardType: TextInputType.phone,
                    )
                  ],
                ),
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;
    }
  }


  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                    child: Text("Descartar"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
