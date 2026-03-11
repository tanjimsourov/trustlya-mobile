import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../presentation/cubit/kyc_cubit.dart';
import '../../presentation/cubit/kyc_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

/// Page to start KYC process.
class KycStartPage extends StatelessWidget {
  const KycStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KycCubit>(
      create: (_) => getIt<KycCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Start KYC')),
        body: BlocBuilder<KycCubit, KycState>(
          builder: (context, state) {
            switch (state.status) {
              case Status.loading:
                return const LoadingWidget();
              case Status.error:
                return shared.ErrorWidgetView(message: state.message);
              case Status.success:
                return const Center(child: Text('KYC process started'));
              default:
                return Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<KycCubit>().start(),
                    child: const Text('Start KYC'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
