import 'package:dash/dash.dart';
import 'package:easy_firebase/src/bloc/FirebaseSignInBloc.dart';
import 'package:easy_firebase/src/bloc/FirebaseSignUpBloc.dart';


part 'Provider.g.dart';


@BlocProvider.register(FirebaseSignInBloc)
@BlocProvider.register(FirebaseSignUpBloc)

abstract class Provider {}