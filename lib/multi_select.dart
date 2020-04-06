import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MultiSelectEvent {}

class MultiSelectToggleEvent extends MultiSelectEvent {
  final int index;

  MultiSelectToggleEvent({
    @required this.index,
  });
}

class MultiSelectState {
  final List<bool> selected;

  MultiSelectState({
    @required this.selected,
  });
}

class MultiSelectBloc extends Bloc<MultiSelectEvent, MultiSelectState> {
  final List<bool> selectedInitialState;

  MultiSelectBloc({
    @required this.selectedInitialState,
  });

  @override
  MultiSelectState get initialState => MultiSelectState(selected: selectedInitialState);

  @override
  Stream<MultiSelectState> mapEventToState(MultiSelectEvent event) async* {
    if (event is MultiSelectToggleEvent) {
      final selected = state.selected.asMap().entries.map((entry) => (entry.key == event.index) ? !entry.value : entry.value).toList();

      yield MultiSelectState(
        selected: selected,
      );
    }
  }
}

typedef void MultiSelectChangeCallback(List<bool> state);

class MultiSelectOption extends StatelessWidget {
  final String title;
  final int index;
  final bool isSelected;

  MultiSelectOption({
    @required this.title,
    @required this.index,
    @required this.isSelected,
  });

  @override
  build(BuildContext context) {
    return BlocBuilder<MultiSelectBloc, MultiSelectState>(
      builder: (BuildContext context, MultiSelectState state) {
        return FilterChip(
          label: Text(title),
          selected: state.selected[index],
          showCheckmark: true,
          onSelected: (_) {
            BlocProvider.of<MultiSelectBloc>(context).add(MultiSelectToggleEvent(index: index));
          },
        );
      },
    );
  }
}

class MultiSelect extends StatelessWidget {
  final String name;
  final List<MultiSelectOption> options;
  final MultiSelectChangeCallback onChange;

  MultiSelect({
    @required this.name,
    @required this.options,
    @required this.onChange,
  });

  @override
  build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final selected = options.map((option) => option.isSelected).toList();
        return MultiSelectBloc(
          selectedInitialState: selected,
        );
      },
      child: BlocListener<MultiSelectBloc, MultiSelectState>(
        listener: (BuildContext context, MultiSelectState state) {
          onChange(state.selected);
        },
        child: Row(
          children: options,
        ),
      ),
    );
  }
}