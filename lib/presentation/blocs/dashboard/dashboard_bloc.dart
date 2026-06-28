import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/data/repositories/dashboard_repository.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({DashboardRepository? dashboardRepository})
      : _dashboardRepository = dashboardRepository ?? DashboardRepository(),
        super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoad);
    on<DashboardRefreshRequested>(_onRefresh);
  }

  final DashboardRepository _dashboardRepository;

  Future<void> _onLoad(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading, clearError: true));
    try {
      final stats = await _dashboardRepository.getDashboardStats();
      emit(state.copyWith(
        status: DashboardStatus.success,
        stats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString().replaceFirst('ServerFailure: ', ''),
      ));
    }
  }

  Future<void> _onRefresh(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final stats = await _dashboardRepository.getDashboardStats();
      emit(state.copyWith(
        status: DashboardStatus.success,
        stats: stats,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('ServerFailure: ', ''),
      ));
    }
  }
}
