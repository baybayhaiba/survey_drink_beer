import 'package:flutter/material.dart';
import 'user.dart';

class ScreeningForm extends StatefulWidget {
  const ScreeningForm({super.key, this.user,this.onSubmit});

  final User? user;
  final Function(User)? onSubmit;

  @override
  _ScreeningFormState createState() => _ScreeningFormState();
}

class _ScreeningFormState extends State<ScreeningForm> {
  final _formKey = GlobalKey<FormState>();

  User _user = User(
    name: 'John Doe',
    dateOfBirth: DateTime(1990, 1, 1),
    gender: 'Nam',
    phoneNumber: '0123456789',
    district: 'District 1',
    ward: 'Ward 1',
    address: '123 Main St, District 1',
  );

  final List<String> _days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> _months =
      List.generate(12, (index) => (index + 1).toString());
  final List<String> _years =
      List.generate(100, (index) => (DateTime.now().year - index).toString());

  @override
  initState() {
    super.initState();
    if (widget.user != null) {
      _user = widget.user!;
    }
  }

  @override
  void didUpdateWidget(covariant ScreeningForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != null) {
      _user = widget.user!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildNameField(),
            SizedBox(height: 20),
            _buildDOBField(),
            SizedBox(height: 20),
            _buildGenderField(),
            SizedBox(height: 20),
            _buildPhoneNumberField(),
            SizedBox(height: 20),
            _buildLocationFields(),
            SizedBox(height: 20),
            _buildAddressField(),
            SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStep('1', 'Thông tin'),
        _buildStep('2', 'Câu hỏi'),
        _buildStep('3', 'Kết quả'),
      ],
    );
  }

  Widget _buildStep(String number, String title) {
    return Column(
      children: [
        CircleAvatar(
          child: Text(number),
          backgroundColor: Colors.blue,
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: _user.name,
      decoration: InputDecoration(
        labelText: 'Họ và tên (*)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập họ và tên';
        }
        return null;
      },
      onSaved: (value) {
        _user.name = value!;
      },
    );
  }

  Widget _buildDOBField() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ngày'),
              DropdownButtonFormField<String>(
                value: _user.dateOfBirth.day.toString(),
                decoration: InputDecoration(
                  hintText: 'Chọn ngày sinh',
                  border: OutlineInputBorder(),
                ),
                items: _days.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  // Handle day change
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tháng'),
              DropdownButtonFormField<String>(
                value: _user.dateOfBirth.month.toString(),
                decoration: InputDecoration(
                  hintText: 'Chọn tháng sinh',
                  border: OutlineInputBorder(),
                ),
                items: _months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  // Handle month change
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Năm sinh (*)'),
              DropdownButtonFormField<String>(
                value: _user.dateOfBirth.year.toString(),
                decoration: InputDecoration(
                  hintText: 'Chọn năm sinh',
                  border: OutlineInputBorder(),
                ),
                items: _years.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  // Handle year change
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn năm sinh';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giới Tính (*)'),
        Row(
          children: [
            Radio<String>(
              value: 'male',
              groupValue: _user.gender,
              onChanged: (value) {
                setState(() {
                  _user.gender = value!;
                });
              },
            ),
            Text('Nam'),
            Radio<String>(
              value: 'female',
              groupValue: _user.gender,
              onChanged: (value) {
                setState(() {
                  _user.gender = value!;
                });
              },
            ),
            Text('Nữ'),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      initialValue: _user.phoneNumber,
      decoration: InputDecoration(
        labelText: 'Số điện thoại (để nhân viên TYT liên hệ tư vấn)(*)',
        border: OutlineInputBorder(),
        prefixText: "(0123456789) ",
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        return null;
      },
      onSaved: (value) {
        _user.phoneNumber = value!;
      },
    );
  }

  Widget _buildLocationFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quận nơi sàng lọc (*)'),
              DropdownButtonFormField<String>(
                value: _user.district,
                decoration: InputDecoration(
                  hintText: 'Chọn quận',
                  border: OutlineInputBorder(),
                ),
                items: User.cities
                    .map((String district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _user.district = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn quận';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phường nơi sàng lọc (*)'),
              DropdownButtonFormField<String>(
                value: _user.ward,
                decoration: InputDecoration(
                  hintText: 'Chọn phường',
                  border: OutlineInputBorder(),
                ),
                items: User.wards.map((String ward) {
                  return DropdownMenuItem<String>(
                    value: ward,
                    child: Text(ward),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _user.ward = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn phường';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      initialValue: _user.address,
      decoration: InputDecoration(
        labelText: 'Địa chỉ nhà đang sinh sống: (số nhà, đường, phường, quận)',
        border: OutlineInputBorder(),
        prefixText: "(số nhà, tên đường, phường, quận) ",
      ),
      onSaved: (value) {
        _user.address = value!;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          // Process the form data (e.g., send it to a server)
          widget.onSubmit?.call(_user);

          // Navigate to the next screen or show a success message
          // For example:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
        }
      },
      child: Text('Tiếp tục'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            vertical: 16.0), // Add some padding to the button
      ),
    );
  }
}
