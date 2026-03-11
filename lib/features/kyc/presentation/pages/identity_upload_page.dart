import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/kyc_cubit.dart';
import '../../presentation/cubit/kyc_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Page to upload identity document.
class IdentityUploadPage extends StatelessWidget {
  const IdentityUploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KycCubit>(
      create: (_) => getIt<KycCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload Identity')),
        body: BlocBuilder<KycCubit, KycState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                return const Center(
                    child: Text('Identity uploaded successfully'));
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<KycCubit>().uploadIdentity('/path/to/id'),
                    child: const Text('Upload Identity'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
