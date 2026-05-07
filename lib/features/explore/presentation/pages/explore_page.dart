import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../app/widgets/custom_container.dart';
import '../bloc/explore_bloc.dart';
import 'planets_page.dart';
import 'solar_system_page.dart';
import 'theories_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          if (state is ExploreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExploreError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)),
            );
          }

          if (state is ExploreLoaded) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SolarSystemPage(planets: state.planets),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomContainer(
                      imgUrl: 'assets/solarSystem.jpg',
                      title: 'Explore Solar System',
                      heightFactor: 1.3,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlanetsPage(planets: state.planets),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: CustomContainer(
                      imgUrl: 'assets/3.png',
                      title: 'Planets',
                      heightFactor: 3.4,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TheoriesPage(articles: state.articles),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomContainer(
                      imgUrl: 'assets/polar-lights-5858656_1920.jpg',
                      title: 'Theories',
                      heightFactor: 2.8,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
