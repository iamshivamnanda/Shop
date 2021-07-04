import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode = FocusNode();
  final _descriptionfocusnode = FocusNode();
  final _imageurlfocusnode = FocusNode();
  final _imageurlcontroller = TextEditingController();
  final _formdata = GlobalKey<FormState>();
  var _initstate = true;
  var initvalue = {'title': '', 'price': '', 'description': '', 'imageurl': ''};
  var _existingproduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _isloading = false;
  @override
  void initState() {
    _imageurlfocusnode.addListener(updateimage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initstate) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _existingproduct =
            Provider.of<Products>(context, listen: false).findbyid(productid);
        initvalue = {
          'title': _existingproduct.title,
          'price': _existingproduct.price.toString(),
          'description': _existingproduct.description,
          'imageurl': ''
        };
        _imageurlcontroller.text = _existingproduct.imageUrl;
      }
    }
    _initstate = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlfocusnode.removeListener(updateimage);
    _pricefocusnode.dispose();
    _descriptionfocusnode.dispose();
    _imageurlfocusnode.dispose();
    _imageurlcontroller.dispose();
    super.dispose();
  }

  void updateimage() {
    if (!_imageurlfocusnode.hasFocus) {
      if ((!_imageurlcontroller.text.startsWith('http') &&
              !_imageurlcontroller.text.startsWith('https')) ||
          (!_imageurlcontroller.text.endsWith('jpg') &&
              !_imageurlcontroller.text.endsWith('png') &&
              !_imageurlcontroller.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final validator = _formdata.currentState.validate();
    if (!validator) {
      return;
    }

    _formdata.currentState.save();
    setState(() {
      _isloading = true;
    });
    try {
      if (_existingproduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateproduct(_existingproduct.id, _existingproduct);
      } else {
        await Provider.of<Products>(context, listen: false)
            .additem(_existingproduct);
      }
    } catch (error) {
      return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An Error Occured'),
                content: Text('Something Went Wrong'),
                actions: [
                  FlatButton(
                    child: Text('Okay!'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveform,
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formdata,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        initialValue: initvalue['title'],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_pricefocusnode),
                        onSaved: (newValue) {
                          _existingproduct = Product(
                              id: _existingproduct.id,
                              title: newValue,
                              description: _existingproduct.description,
                              price: _existingproduct.price,
                              imageUrl: _existingproduct.imageUrl,
                              isfav: _existingproduct.isfav);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Provide Title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: initvalue['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusnode,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionfocusnode),
                        onSaved: (newValue) {
                          _existingproduct = Product(
                              id: _existingproduct.id,
                              title: _existingproduct.title,
                              description: _existingproduct.description,
                              price: double.parse(newValue),
                              imageUrl: _existingproduct.imageUrl,
                              isfav: _existingproduct.isfav);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Provide Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Use Numbers Only';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter Price More than Zero';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        initialValue: initvalue['description'],
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionfocusnode,
                        onSaved: (newValue) {
                          _existingproduct = Product(
                              id: _existingproduct.id,
                              title: _existingproduct.title,
                              description: newValue,
                              price: _existingproduct.price,
                              imageUrl: _existingproduct.imageUrl,
                              isfav: _existingproduct.isfav);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Provide Description';
                          }
                          if (value.length < 10) {
                            return 'Please Provide Description Having Atleast 10 Characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: _imageurlcontroller.text.isEmpty
                                ? Text('Enter Image Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageurlcontroller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter Image Url'),
                              focusNode: _imageurlfocusnode,
                              textInputAction: TextInputAction.done,
                              controller: _imageurlcontroller,
                              onSaved: (newValue) {
                                _existingproduct = Product(
                                    id: _existingproduct.id,
                                    title: _existingproduct.title,
                                    description: _existingproduct.description,
                                    price: _existingproduct.price,
                                    imageUrl: newValue,
                                    isfav: _existingproduct.isfav);
                              },
                              onFieldSubmitted: (value) => _saveform(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Provide ImageUrl';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please Enter A Valid URL';
                                }
                                if (!value.endsWith('jpg') &&
                                    !value.endsWith('png') &&
                                    !value.endsWith('jpeg')) {
                                  return 'Please Enter A Valid Image URL';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
