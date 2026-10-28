import 'package:flutter/material.dart';
import '../../domain/entities/worker.dart';

class WorkerFormScreen extends StatefulWidget {
  final Function(WorkerEntity) onWorkerAdded;

  const WorkerFormScreen({super.key, required this.onWorkerAdded});

  @override
  State<WorkerFormScreen> createState() => _WorkerFormScreenState();
}

class _WorkerFormScreenState extends State<WorkerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dniController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _policyNumberController = TextEditingController();
  final _insurerNameController = TextEditingController();

  DateTime? _insuranceExpiresAt;

  @override
  void dispose() {
    _dniController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _policyNumberController.dispose();
    _insurerNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Regla HU-001: Si no tiene seguro válido, queda en Pendiente de habilitación
    InsuranceEntity? insurance;
    WorkerStatus status = WorkerStatus.pendienteHabilitacion;

    if (_policyNumberController.text.isNotEmpty &&
        _insurerNameController.text.isNotEmpty &&
        _insuranceExpiresAt != null) {
      insurance = InsuranceEntity(
        policyNumber: _policyNumberController.text.trim(),
        insurerName: _insurerNameController.text.trim(),
        expiresAt: _insuranceExpiresAt!,
      );
      if (insurance.isValid) {
        status = WorkerStatus.habilitado;
      }
    }

    final newWorker = WorkerEntity(
      id: 'w-${DateTime.now().millisecondsSinceEpoch}',
      dni: _dniController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
      status: status,
      insurance: insurance,
    );

    widget.onWorkerAdded(newWorker);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(status == WorkerStatus.habilitado
            ? '¡Desmalezador registrado y Habilitado!'
            : 'Desmalezador registrado con estado: Pendiente de habilitación'),
        backgroundColor: status == WorkerStatus.habilitado ? Colors.green : Colors.orange,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Desmalezador (HU-001)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos del Trabajador',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dniController,
                decoration: const InputDecoration(labelText: 'DNI *', hintText: 'Ej. 38123456'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'El DNI es obligatorio';
                  if (val.trim().length < 7) return 'Ingrese un DNI válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (val) => val == null || val.trim().isEmpty ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido *'),
                validator: (val) => val == null || val.trim().isEmpty ? 'El apellido es obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono de Contacto'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              const Text(
                'Seguro de Accidentes Personales (HU-002)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _insurerNameController,
                decoration: const InputDecoration(labelText: 'Aseguradora (ej. Rivadavia, Sancor)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _policyNumberController,
                decoration: const InputDecoration(labelText: 'Número de Póliza'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_insuranceExpiresAt == null
                    ? 'Fecha de Vencimiento de Póliza'
                    : 'Vence: ${_insuranceExpiresAt!.day}/${_insuranceExpiresAt!.month}/${_insuranceExpiresAt!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (picked != null) {
                    setState(() {
                      _insuranceExpiresAt = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Guardar Desmalezador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
