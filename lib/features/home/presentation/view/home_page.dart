import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/core/resources/app_strings.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/features/home/presentation/bloc/home_bloc.dart';
import 'package:nuntium/features/home/presentation/view/widgets/article_card.dart';
import 'package:nuntium/features/home/presentation/view/widgets/articles_loading_error.dart';
import 'package:nuntium/features/home/presentation/view/widgets/articles_loading_indicator.dart';
import 'package:nuntium/features/home/presentation/view/widgets/category_selector.dart';
import 'package:nuntium/features/home/presentation/view/widgets/home_search_bar.dart';

import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showScrollUpButton = false;
  late final ScrollController _scrollController;
  late final TextEditingController _searchFieldController;

  bool _isLoadingStatus(BuildContext context) {
    return context.read<HomeBloc>().state.status == HomeStatus.loading;
  }

  bool _isLoadingNextPageStatus(BuildContext context) {
    return context.read<HomeBloc>().state.status == HomeStatus.loadingNextPage;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _onScroll() {
    // FAB visibility — pure UI, lives here not in BLoC
    final shouldShow = _scrollController.offset > 400;
    if (shouldShow != _showScrollUpButton) {
      setState(() {
        _showScrollUpButton = shouldShow;
      });
    }

    // Pagination trigger — dispatch event when 5 items left
    if (_isLoadingStatus(context) || _isLoadingNextPageStatus(context)) {
      return;
    }
    final itemHeight = 216.h;
    const triggerMargin = 5; //number of items left to trigger the event
    final maxScroll = _scrollController.position.maxScrollExtent;
    final triggerPosition = maxScroll - itemHeight * triggerMargin;

    if (_scrollController.offset >= triggerPosition) {
      context.read<HomeBloc>().add(HomeNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showScrollUpButton ? 1.0 : 0.0,
          child: Visibility(
            visible: _showScrollUpButton,
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppColors.purplePrimary,
              mini: true,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ),

        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Page Header
            SliverToBoxAdapter(
              child: Header(
                horizentalPadding: 20.w,
                title: context.tr(AppStrings.homePageTitle),
                subTtitle: context.tr(AppStrings.homePageSubTitle),
              ),
            ),

            // Search
            SliverToBoxAdapter(
              child: HomeSearchBar(
                searchFieldController: _searchFieldController,
                onChanged: (query) => context.read<HomeBloc>().add(
                  HomeSearchSubmitted(query: query),
                ),
                onSearchPressed: () => context.read<HomeBloc>().add(
                  HomeSearchSubmitted(query: _searchFieldController.text),
                ),
              ),
            ),

            SliverPadding(padding: EdgeInsets.only(top: 24.h)),

            // News Categories
            const SliverToBoxAdapter(child: CategorySelector()),

            SliverPadding(padding: EdgeInsets.only(top: 24.h)),

            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.articles != current.articles,
              builder: (context, state) => _buildContent(state),
            ),

            // إضافة مسافة في الأسفل لضمان عدم اختفاء الكروت خلف الـ BottomNavBar
            SliverToBoxAdapter(child: SizedBox(height: 80.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeState state) {
    final status = state.status;

    // First Page Loading
    if (status == HomeStatus.loading && state.articles.isEmpty) {
      return SliverToBoxAdapter(child: const ArticlesLoadingIndicator());
      // return SliverFillRemaining(child: const ArticlesLoadingIndicator());
    }

    // First Page Error
    if (status == HomeStatus.error && state.articles.isEmpty) {
      return SliverFillRemaining(
        child: PageLoadingError(
          errorMessage:
              state.errorMessage ?? context.tr(AppStrings.errorLoadingNews),
          onRefreshPressed: () {
            context.read<HomeBloc>().add(HomeRefreshRequested());
          },
        ),
      );
    }

    // Empty result
    if (status == HomeStatus.loaded && state.articles.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text(context.tr(AppStrings.noArticlesFound))),
      );
    }

    return SliverList.builder(
      itemCount: state.articles.length + 1, // +1 for spinner slot

      itemBuilder: (context, index) {
        // Last slot — show spinner or nothing
        if (index == state.articles.length) {
          return state.status == HomeStatus.loadingNextPage
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              : const SizedBox.shrink();
        }

        final article = state.articles[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Center(
            key: ValueKey(article.id),
            child: ArticleCard(
              article: article,
              onPressed: () => _onArticlePressed(article),
              onBookmarkPressed: () => context.read<HomeBloc>().add(
                HomeBookmarkToggled(article: article),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onArticlePressed(Article article) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(Routes.articleView, arguments: article);
  }
}
