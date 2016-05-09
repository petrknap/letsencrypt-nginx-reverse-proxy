<?php

namespace PetrKnap\Php\FileStorage;

/**
 * @author   Petr Knap <dev@petrknap.cz>
 * @since    2016-05-09
 * @category FileStorage
 * @package  PetrKnap\Php\FileStorage
 * @license  https://github.com/petrknap/php-filestorage/blob/master/LICENSE MIT
 */
interface StorageManagerInterface
{
    /**
     * Returns path to storage
     *
     * @return string
     */
    public function getPathToStorage();

    /**
     * @return int
     */
    public function getStoragePermissions();

    /**
     * Generates real path to file
     *
     * @param string $pathToFile user-friendly (readable) path to file
     * @return string
     */
    public function generateRealPath($pathToFile);

    /**
     * Assigns file to storage
     *
     * @param FileInterface $file
     * @return $this
     */
    public function assignFile(FileInterface $file);

    /**
     * Unassigns file from storage
     *
     * @param FileInterface $file
     * @return $this
     */
    public function unassignFile(FileInterface $file);

    /**
     * Returns all stored files
     *
     * @return \Iterator|FileInterface[]
     */
    public function getFiles();
}
