import { Box } from '../../components';

export const BeakerContents = props => {
  const { beakerLoaded, beakerContents } = props;
  return (
    <Box>
      {!beakerLoaded && (
        <Box color="label">
          No beaker loaded.
        </Box>
      ) || beakerContents.length === 0 && (
        <Box color="label">
          Beaker is empty.
        </Box>
      )}
      {beakerContents.map(chemical => (
        <Box key={chemical.name} color="label">
<<<<<<< HEAD:tgui-next/packages/tgui/interfaces/common/BeakerContents.js
          {chemical.volume} units of {chemical.name}, Purity: {chemical.purity}
=======
          {chemical.volume} units of {chemical.name} {chemical.purity < 1 && "(Purity: "+chemical.purity+")"}
>>>>>>> 8e72c61d2d002ee62e7a3b0b83d5f95aeddd712d:tgui/packages/tgui/interfaces/common/BeakerContents.js
        </Box>
      ))}
    </Box>
  );
};
